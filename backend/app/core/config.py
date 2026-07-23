import os
from dotenv import load_dotenv

load_dotenv()


class Settings:
    AWS_REGION = os.getenv("AWS_REGION", "us-east-1")
    AWS_ENDPOINT_URL = os.getenv("AWS_ENDPOINT_URL", "http://localhost:4566")

    AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID", "test")
    AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY", "test")

    S3_BUCKET = os.getenv("S3_BUCKET", "cloud-native-uploads")
    DYNAMODB_TABLE = os.getenv("DYNAMODB_TABLE", "files")
    USERS_TABLE = os.getenv("USERS_TABLE", "users")
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")
    JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 60))
    SQS_QUEUE_NAME = os.getenv("SQS_QUEUE_NAME","file-processing-queue")



settings = Settings()