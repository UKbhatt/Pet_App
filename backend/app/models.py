from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime

class RegisterIn(BaseModel): 
    email: EmailStr
    password: str = Field(min_length=6)

class LoginIn(BaseModel): 
    email: EmailStr
    password: str

class TokenOut(BaseModel):
    token: str

class PetIn(BaseModel):
    name: str = Field(min_length=1)
    type: str = Field(min_length=1)
    age: int = Field(ge=0)
    notes: Optional[str] = ""

class PetOut(BaseModel):
    id: str
    name: str
    type: str
    age: int
    notes: str
    created_at: datetime
    photo_url: Optional[str] = None 

class PetUpdate(BaseModel):
    name: Optional[str] = None
    type: Optional[str] = None
    age: Optional[int] = Field(default=None, ge=0)
    notes: Optional[str] = None