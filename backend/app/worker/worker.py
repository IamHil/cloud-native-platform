import json
import os
import time

from app.services.s3_service import s3_service
from app.services.sqs_service import sqs_service
from app.services.dynamodb_service import dynamodb_service

while True:

    messages = sqs_service.receive_messages()

    if not messages:
        print("No messages...")
        time.sleep(2)
        continue

    for message in messages:

        body = json.loads(message["Body"])
        print(f"Processing {body['filename']}")

        dynamodb_service.update_status(body["file_id"],"PROCESSING")

        time.sleep(5)
        dynamodb_service.update_status(body["file_id"],"COMPLETED")
        sqs_service.delete_message(message["ReceiptHandle"])
        print("Completed")
        