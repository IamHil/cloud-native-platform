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

        self.create_table()

        self.table = self.client.Table(
            settings.DYNAMODB_TABLE
        )

    def create_table(self):

        existing_tables = self.client.meta.client.list_tables()["TableNames"]

        if settings.DYNAMODB_TABLE in existing_tables:
            return

        self.client.create_table(
            TableName=settings.DYNAMODB_TABLE,
            KeySchema=[
                {
                    "AttributeName": "file_id",
                    "KeyType": "HASH"
                }
            ],
            AttributeDefinitions=[
                {
                    "AttributeName": "file_id",
                    "AttributeType": "S"
                }
            ],
            BillingMode="PAY_PER_REQUEST"
        )

        self.client.meta.client.get_waiter(
            "table_exists"
        ).wait(
            TableName=settings.DYNAMODB_TABLE
        )

    def save_file_metadata(self, item):
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