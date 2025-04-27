from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
import models, crud, schemas

# اتصال به دیتابیس
DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# ساخت جداول
models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# تابعی برای دریافت session دیتابیس
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ایجاد کاربر جدید
@app.post("/create_user/", response_model=schemas.UserOut)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.create_user(db, user)
    return db_user

# لاگین


@app.post("/login/")
def login(user: schemas.UserLogin, db: Session = Depends(get_db)):
    db_user = crud.authenticate_user(db, user)
    if not db_user:
        raise HTTPException(status_code=403, detail="Invalid credentials")
    return {"message": "Login successful!"}