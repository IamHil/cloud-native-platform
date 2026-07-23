from datetime import datetime, UTC
from uuid import uuid4

from fastapi import APIRouter, File, HTTPException, UploadFile

from app.services.dynamodb_service import dynamodb_service
from app.services.s3_service import s3_service
from app.services.sqs_service import sqs_service


router = APIRouter(
    prefix="/files",
    tags=["Files"]
)

ALLOWED_TYPES = [
    "application/pdf",
    "image/png",
    "image/jpeg"
]

MAX_SIZE = 10 * 1024 * 1024  # 10 MB


@router.get("/")
def list_files():
    return {
        "files": s3_service.list_files()
    }


@router.post("/upload")
def upload_file(file: UploadFile = File(...)):

    try:

        # Validate file type
        if file.content_type not in ALLOWED_TYPES:
            raise HTTPException(
                status_code=400,
                detail="Unsupported file type"
            )

        # Read file to check size
        contents = file.file.read()

        if len(contents) > MAX_SIZE:
            raise HTTPException(
                status_code=400,
                detail="File size exceeds 10 MB"
            )

        # Reset pointer after reading
        file.file.seek(0)

        # Upload to S3
        result = s3_service.upload_file(
            file.file,
            file.filename
        )

        # Save metadata
        metadata = {
            "file_id": str(uuid4()),
            "filename": file.filename,
            "s3_key": result["key"],
            "uploaded_at": datetime.now(UTC).isoformat(),
            "content_type": file.content_type,
            "size": len(contents),
            "status": "ACTIVE"
        }

        dynamodb_service.save_file_metadata(metadata)

        sqs_service.send_message({
        "file_id": metadata["file_id"],
        "filename": metadata["filename"],
        "s3_key": metadata["s3_key"]})

        return {
            "message": "Upload successful",
            "metadata": metadata
        }

    except HTTPException:
        raise

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


@router.get("/metadata")
def get_metadata():
    return {
        "files": dynamodb_service.get_all_files()
    }