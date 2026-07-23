import boto3

from app.core.config import settings


class S3Service:

    def __init__(self):

        print("=" * 60)
        print("S3 Endpoint:", settings.AWS_ENDPOINT_URL)
        print("Bucket:", settings.S3_BUCKET)

        self.client = boto3.client(
            "s3",
            endpoint_url=settings.AWS_ENDPOINT_URL,
            region_name=settings.AWS_REGION,
            aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
        )
        print(self.client.list_buckets())
        print("=" * 60)

    def list_files(self):

        response = self.client.list_objects_v2(
            Bucket=settings.S3_BUCKET
        )

        contents = response.get("Contents", [])

        return [
            obj["Key"]
            for obj in contents
        ]
    
    def upload_file(self, file, key):
        self.client.upload_fileobj(
            file,
            settings.S3_BUCKET,
            key
        )
        return {
            "message": "Upload successful",
            "key": key
        }


s3_service = S3Service()