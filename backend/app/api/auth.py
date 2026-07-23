from fastapi import APIRouter, HTTPException

from app.models.user import UserRegister, UserLogin

from app.services.user_service import user_service

from app.auth.security import hash_password, verify_password

from app.auth.jwt_handler import create_access_token

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)

@router.post("/register")
def register(user: UserRegister):

    existing_user = user_service.get_user(user.email)

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="User already exists"
        )

    new_user = {
        "email": user.email,
        "username": user.username,
        "password": hash_password(user.password),
        "role": "user"
    }

    user_service.create_user(new_user)

    return {
        "message": "User registered successfully"
    }

@router.post("/login")
def login(user: UserLogin):

    db_user = user_service.get_user(user.email)

    if not db_user:
        raise HTTPException(
            status_code=401,
            detail="Invalid credentials"
        )

    if not verify_password(
        user.password,
        db_user["password"]
    ):
        raise HTTPException(
            status_code=401,
            detail="Invalid credentials"
        )

    token = create_access_token(
        {
            "sub": db_user["email"],
            "role": db_user["role"]
        }
    )

    return {
        "access_token": token,
        "token_type": "bearer"
    }