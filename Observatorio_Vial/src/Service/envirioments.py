from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    SECRET_KEY: str 
    ALGORITHM: str
    BD_USER:str
    BD_PASSWORD:str
    BD_NAME:str

    class Config:
        env_file = ".env" 
        extra = "ignore"

settings = Settings()
