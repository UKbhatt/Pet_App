from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, status
from datetime import datetime
from uuid import uuid4
from pathlib import Path
from ..models import PetIn, PetOut
from .. import database
from ..deps import get_current_user
from ..config import UPLOAD_DIR

router = APIRouter(prefix="/pets", tags=["pets"])

def to_pet_out(doc) -> PetOut:
    return PetOut(
        id=str(doc["_id"]),
        name=doc["name"],
        type=doc["type"],
        age=doc["age"],
        notes=doc.get("notes", ""),
        created_at=doc["created_at"],
        photo_url=doc.get("photo_url"),   
    )

@router.get("", response_model=list[PetOut])
async def list_pets(user=Depends(get_current_user)):
    cursor = database.db.pets.find({"user_id": user["_id"]}).sort("created_at", -1)
    return [to_pet_out(doc) async for doc in cursor]

@router.post("", response_model=PetOut, status_code=201)
async def add_pet(payload: PetIn, user=Depends(get_current_user)):
    doc = {
        "user_id": user["_id"],
        "name": payload.name.strip(),
        "type": payload.type.strip(),
        "age": payload.age,
        "notes": (payload.notes or "").strip(),
        "created_at": datetime.utcnow(),
        "photo_url": None,   # NEW default
    }
    res = await database.db.pets.insert_one(doc)
    doc["_id"] = res.inserted_id
    return to_pet_out(doc)

# NEW: upload a photo (PNG/JPEG/WEBP). Optional feature.
@router.post("/{pet_id}/photo", response_model=PetOut)
async def upload_pet_photo(
    pet_id: str,
    file: UploadFile = File(...),
    user=Depends(get_current_user)
):
    # Check pet belongs to user
    from bson import ObjectId
    try:
        oid = ObjectId(pet_id)
    except Exception:
        raise HTTPException(status_code=404, detail="Pet not found")

    pet = await database.db.pets.find_one({"_id": oid, "user_id": user["_id"]})
    if not pet:
        raise HTTPException(status_code=404, detail="Pet not found")

    # Validate content type
    ct = (file.content_type or "").lower()
    if ct not in {"image/jpeg", "image/png", "image/webp"}:
        raise HTTPException(status_code=400, detail="Only jpeg/png/webp allowed")

    ext = {"image/jpeg": "jpg", "image/png": "png", "image/webp": "webp"}[ct]
    uploads = Path(UPLOAD_DIR)
    uploads.mkdir(parents=True, exist_ok=True)
    fname = f"{pet_id}_{uuid4().hex}.{ext}"
    fpath = uploads / fname

    data = await file.read()
    if len(data) > 5 * 1024 * 1024: 
        raise HTTPException(status_code=400, detail="File too large (max 5MB)")
    fpath.write_bytes(data)

    photo_url = f"/uploads/{fname}"
    await database.db.pets.update_one(
        {"_id": oid}, {"$set": {"photo_url": photo_url}}
    )

    pet = await database.db.pets.find_one({"_id": oid})
    return to_pet_out(pet)
