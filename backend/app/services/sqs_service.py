import json
import boto3

from app.core.config import settings


class SQSService:

    def __init__(self):

        self.client = boto3.client(
            "sqs",
            region_name=settings.AWS_REGION,
            endpoint_url=settings.AWS_ENDPOINT_URL,
            aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
        )

        # Queue is created by Terraform — app looks it up by name.
        self.queue_url = self._get_queue_url()

    def _get_queue_url(self):
        try:
            response = self.client.get_queue_url(
                QueueName=settings.SQS_QUEUE_NAME
            )
            return response["QueueUrl"]
        except self.client.exceptions.QueueDoesNotExist:
            raise RuntimeError(
                f"SQS queue '{settings.SQS_QUEUE_NAME}' not found. "
                "Run: cd infrastructure/terraform && terraform apply"
            ) from None

    def send_message(self, message: dict):

        self.client.send_message(
            QueueUrl=self.queue_url,
            MessageBody=json.dumps(message)
        )

    def receive_messages(self):

        response = self.client.receive_message(
            QueueUrl=self.queue_url,
            MaxNumberOfMessages=10,
            WaitTimeSeconds=2
        )

        return response.get("Messages", [])

    def delete_message(self, receipt_handle):

        self.client.delete_message(
            QueueUrl=self.queue_url,
            ReceiptHandle=receipt_handle,
        )


sqs_service = SQSService()