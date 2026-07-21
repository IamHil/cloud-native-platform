from fastapi import APIRouter, UploadFile, File

from app.services.s3_service import s3_service

router = APIRouter(
    prefix="/files",
    tags=["Files"]
)


@router.get("/")
def list_files():

    return {
        "files": s3_service.list_files()
    }


@router.post("/upload")
def upload_file(file: UploadFile = File(...)):

    result = s3_service.upload_file(
        file.file,
        file.filename
    )

    return result