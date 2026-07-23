import boto3

from botocore.exceptions import ClientError

from app.core.config import settings


class UserService:

    def __init__(self):

        self.client = boto3.resource(
            "dynamodb",
            region_name=settings.AWS_REGION,
            endpoint_url=settings.AWS_ENDPOINT_URL,
            aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
        )

        self.create_table()

        self.table = self.client.Table(
            settings.USERS_TABLE
        )

    def create_table(self):
        existing_tables = self.client.meta.client.list_tables()["TableNames"]

        if settings.USERS_TABLE in existing_tables:
            return
        self.client.create_table(
            TableName=settings.USERS_TABLE,
            KeySchema=[
                {
                    "AttributeName": "email",
                    "KeyType": "HASH"
                }
            ],
            AttributeDefinitions=[
                {
                    "AttributeName": "email",
                    "AttributeType": "S"
                }
            ],
            BillingMode= "PAY_PER_REQUEST"
        )

        self.client.meta.client.get_waiter("table_exists").wait(
            TableName=settings.USERS_TABLE
        )

    def create_user(self, user: dict):

        self.table.put_item(Item=user)

    def get_user(self, email: str):
        response = self.table.get_item(
            Key={
                "email": email
            }
        )
        return response.get("Item")
    
    def list_users(self):
        response = self.table.scan()
        return response.get("Items", [])
    
    def delete_user(self, email: str):
        try:
            self.table.delete_item(
                Key={
                    "email": email
                }
            )
        except ClientError as e:
            print(f"Error deleting user: {e.response['Error']['Message']}")

user_service = UserService()

