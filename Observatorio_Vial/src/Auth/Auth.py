from jose import jwt,JWSError
from src.Service.envirioments import settings
from fastapi.exceptions import HTTPException
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer
from src.Database.BD import BD
class auth():

    oauth2_bear = OAuth2PasswordBearer(tokenUrl="/login")
    

    SECRET_KEY = settings.SECRET_KEY

    ALGORITHM = settings.ALGORITHM 

    pwd_context = CryptContext(schemes=["bcrypt"],deprecated="auto")


    
    async def Auth_user(user:str,password:str):
            
        p = await BD.valid_UserBD(user)
        valid =p["valid_pass"]
        if valid == False:
            raise HTTPException(
            status_code=401,
            detail={"message":"Invalid User" ,"Error":"incorrecto usuario o contraseña"})
        
        
        passwordBD = p["password"]
        token = p["token"]
        
        valid_pass = auth.verify_password(password,passwordBD)
        print(valid_pass)
        if valid_pass:
           return  {"message": "User Valid", "Response": token} 
        
        raise HTTPException(
            status_code=401,
            detail={"message":"Invalid password" ,"Error":"Password incorrecto"})

    def create_access_token(data: dict):
        to_encode = data.copy()
        encoded_jwt = jwt.encode(to_encode, auth.SECRET_KEY , auth.ALGORITHM)
        return encoded_jwt

    def jwtdecode(token:str):
        decode_jwt = jwt.decode(token,auth.SECRET_KEY, auth.ALGORITHM)
        return decode_jwt
    
    def hash_password(password:str):
        pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
        password_hash= pwd_context.hash(password)
        return password_hash

    def verify_password(password:str, hashed_password:str):
    
        return auth.pwd_context.verify(password, hashed_password,"bcrypt")