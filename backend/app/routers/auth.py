from fastapi import APIRouter, HTTPException, status
from ..models import RegisterIn, LoginIn, TokenOut
from ..auth import hash_password, verify_password, create_access_token
from .. import database  

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/register", status_code=201)
async def register(payload: RegisterIn):
    existing = await database.db.users.find_one({"email": payload.email})
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed = hash_password(payload.password)
    res = await database.db.users.insert_one({"email": payload.email, "password_hash": hashed})
    return {"message": "registered", "user_id": str(res.inserted_id)}

@router.post("/login", response_model=TokenOut)
async def login(payload: LoginIn):
    user = await database.db.users.find_one({"email": payload.email})
    if not user or not verify_password(payload.password, user["password_hash"]):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
    token = create_access_token(str(user["_id"]))
    return {"token": token}
