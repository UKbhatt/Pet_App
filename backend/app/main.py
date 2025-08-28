from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .database import connect_db, close_db
from .config import ALLOWED_ORIGINS
from .routers import auth as auth_router
from .routers import pets as pets_router

app = FastAPI(title="Pets API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS or ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup():
    await connect_db()

@app.on_event("shutdown")
async def shutdown():
    await close_db()

app.include_router(auth_router.router)
app.include_router(pets_router.router)

@app.get("/")
def root():
    return {"ok": True, "service": "pets-api"}
