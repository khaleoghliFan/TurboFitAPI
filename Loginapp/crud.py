from sqlalchemy.orm import Session
import models, schemas
from utils import hash_password, verify_password

def get_user(db: Session, username: str):
    return db.query(models.User).filter(models.User.username == username).first()

def create_user(db: Session, user: schemas.UserCreate):
    hashed_password = hash_password(user.password)
    db_user = models.User(username=user.username, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def authenticate_user(db: Session, user: schemas.UserLogin):
    db_user = get_user(db, user.username)
    if db_user and verify_password(user.password, db_user.hashed_password):
        return db_user
    return None
