from fastapi import APIRouter, Depends
from datetime import datetime
from ..models import PetIn, PetOut
from .. import database
from ..deps import get_current_user

router = APIRouter(prefix="/pets", tags=["pets"])

def to_pet_out(doc) -> PetOut:
    return PetOut(
        id=str(doc["_id"]),
        name=doc["name"],
        type=doc["type"],
        age=doc["age"],
        notes=doc.get("notes", ""),
        created_at=doc["created_at"],
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
    }
    res = await database.db.pets.insert_one(doc)
    doc["_id"] = res.inserted_id
    return to_pet_out(doc)
