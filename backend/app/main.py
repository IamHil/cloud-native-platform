from fastapi import FastAPI

app = FastAPI(
    title="Cloud Native Platform API",
    version="1.0.0"
)

@app.get("/")
def root():
    return {
        "message": "Cloud Native Platform API is running!"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy"
    }