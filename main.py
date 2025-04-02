from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware #برای دسترسی به postman

app = FastAPI()
# تنظیمات CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # اینجا می‌توانید فقط دامنه‌های خاص را مشخص کنید
    allow_credentials=True,
    allow_methods=["*"],  # به همه متدها دسترسی بدهید
    allow_headers=["*"],  # به همه هدرها دسترسی بدهید
)

@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/hello/{name}")
async def say_hello(name: str):
    return {"message": f"Hello {name}"}
