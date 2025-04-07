from fastapi import FastAPI
from .config import settings
from .db import init_db

app = FastAPI()

@app.on_event("startup")
async def startup():
    await init_db()

@app.get("/")
def read_root():
    return {"message": f"API corriendo en modo: {settings.ENVIRONMENT}"}