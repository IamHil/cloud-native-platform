from fastapi import FastAPI

from app.api.health import router as health_router
from app.api.files import router as files_router

app = FastAPI(
    title="Cloud Native Platform API",
    version="1.0.0"
)

app.include_router(health_router)
app.include_router(files_router)


@app.get("/")
def root():
    return {
        "message": "Cloud Native Platform API is running!"
    }