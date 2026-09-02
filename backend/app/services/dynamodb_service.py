import boto3

from app.core.config import settings


class DynamoDBService:

    def __init__(self):

        self.client = boto3.resource(
            "dynamodb",
            endpoint_url=settings.AWS_ENDPOINT_URL,
            aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
            region_name=settings.AWS_REGION,
        )

        # Table is created by Terraform — app only reads/writes data.
        self.table = self.client.Table(settings.DYNAMODB_TABLE)(self, item):
        self.table.put_item(Item=item)

    def get_all_files(self):
        response = self.table.scan()
        return response.get("Items", [])

    def update_status(self, file_id: str, status: str):
        self.table.update_item(
            Key={"file_id": file_id},
            UpdateExpression="SET #s = :status",
            ExpressionAttributeNames={"#s": "status"},
            ExpressionAttributeValues={":status": status},
        )


dynamodb_service = DynamoDBService()