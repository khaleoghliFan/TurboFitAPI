from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import Column, Integer, String, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# مدل دیتابیس
class Item(Base):
    __tablename__ = "items"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String)

# ایجاد جدول‌ها
Base.metadata.create_all(bind=engine)
class ItemCreate(BaseModel):
    title: str
    description: str
#database
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.post("/items/")
def create_item(title: str, description: str, db: Session = Depends(get_db)):
    item = Item(title=title, description=description)
    db.add(item)
    db.commit()
    db.refresh(item)
    print(f"Item saved: {item.title} - {item.description}")

    return item

@app.get("/items/")
def read_items(db: Session = Depends(get_db)):
    return db.query(Item).all()
