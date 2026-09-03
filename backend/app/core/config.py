import os
from dotenv import load_dotenv

load_dotenv()


def _require_jwt_secret() -> str:
    """Reject missing or obviously weak JWT secrets."""
    secret = os.getenv("JWT_SECRET_KEY", "").strip()
    weak = {"", "secret", "changeme", "password", "123456", "s123456789"}
    if secret in weak or len(secret) < 16:
        raise ValueError(
            "JWT_SECRET_KEY must be set to a strong secret (min 16 chars). "
            "Do not use defaults like 'secret' or 's123456789'."
        )
    return secret


class Settings:
    AWS_REGION = os.getenv("AWS_REGION", "us-east-1")
    AWS_ENDPOINT_URL = os.getenv("AWS_ENDPOINT_URL", "http://localhost:4566")

    AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID", "test")
    AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY", "test")

    S3_BUCKET = os.getenv("S3_BUCKET", "cloud-native-uploads")
    DYNAMODB_TABLE = os.getenv("DYNAMODB_TABLE", "files")
    USERS_TABLE = os.getenv("USERS_TABLE", "users")

    JWT_SECRET_KEY = _require_jwt_secret()
    JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))

    SQS_QUEUE_NAME = os.getenv("SQS_QUEUE_NAME", "file-processing-queue")

    # Comma-separated origins, e.g. "http://localhost:3000,http://cloud-native.local"
    CORS_ORIGINS = [
        origin.strip()
        for origin in os.getenv(
            "CORS_ORIGINS",
            "http://localhost:3000,http://localhost:8000,http://cloud-native.local",
        ).split(",")
        if origin.strip()
    ]

    RATE_LIMIT = os.getenv("RATE_LIMIT", "60/minute")


settings = Settings()
