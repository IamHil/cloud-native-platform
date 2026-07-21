import os
from dotenv import load_dotenv

load_dotenv()


class Settings:
    AWS_REGION = os.getenv("AWS_REGION", "us-east-1")
    AWS_ENDPOINT_URL = os.getenv("AWS_ENDPOINT_URL", "http://localhost:4566")

    AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID", "test")
    AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY", "test")

    S3_BUCKET = os.getenv("S3_BUCKET", "cloud-native-uploads")


settings = Settings()