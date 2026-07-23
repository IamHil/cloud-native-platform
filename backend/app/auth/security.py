import hashlib
import hmac
import importlib
import os

CryptContext = None
try:
    passlib_context = importlib.import_module("passlib.context")
    CryptContext = passlib_context.CryptContext
except ImportError:
    CryptContext = None

if CryptContext is not None:
    pwd_context = CryptContext(
        schemes=["bcrypt"],
        deprecated="auto"
    )
else:
    class _FallbackContext:
        def hash(self, password: str) -> str:
            salt = os.urandom(16)
            key = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 100_000)
            return f"{salt.hex()}${key.hex()}"

        def verify(self, plain_password: str, hashed_password: str) -> bool:
            try:
                salt_hex, key_hex = hashed_password.split("$", 1)
            except ValueError:
                return False
            salt = bytes.fromhex(salt_hex)
            expected = bytes.fromhex(key_hex)
            actual = hashlib.pbkdf2_hmac("sha256", plain_password.encode(), salt, 100_000)
            return hmac.compare_digest(actual, expected)

    pwd_context = _FallbackContext()


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(
    plain_password: str,
    hashed_password: str
) -> bool:
    return pwd_context.verify(
        plain_password,
        hashed_password
    )