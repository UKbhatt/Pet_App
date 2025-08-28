from motor.motor_asyncio import AsyncIOMotorClient
from .config import MONGODB_URI, MONGO_DB

client: AsyncIOMotorClient | None = None
db = None

async def connect_db():
    """Create client and ping MongoDB."""
    global client, db
    client = AsyncIOMotorClient(MONGODB_URI)
    db = client[MONGO_DB]
    await db.command("ping")
    await db.users.create_index("email", unique=True)

async def close_db():
    global client
    if client:
        client.close()
