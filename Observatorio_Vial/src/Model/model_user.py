from pydantic import BaseModel, field_validator,Field,EmailStr
from src.Auth.Auth import auth
from src.Database.BD import BD
from typing import Optional
from fastapi import HTTPException

class User_Sign_in(BaseModel):
    name:str = Field(min_length=4)
    password:str = Field(min_length=8)
    email:EmailStr
    token:Optional[str] = Field(default="")
    estado:Optional[bool]= Field(default=False)
    

    @field_validator('name')
    def validar_email(cls, name):
        name_sin_espacio = name.replace(" ","") # filtar para espacios
        if name_sin_espacio == "":
            raise ValueError('El campo name esta vacio')
        name_minusculas = name_sin_espacio.lower()
        return name_minusculas
    
 
    
    @field_validator('password')
    def validar_password(cls, password):
        password = password.replace(" ","") # filtar para espacios
        if password == "":
            raise ValueError('El campo password esta vacio')
        return password
    
    async def create_user(user:BaseModel):
       
        try:
            usuario_dict = {"name":user.name,"email":user.email}
            bcrytp_password = auth.hash_password(user.password)
            user.password = bcrytp_password
            token =  auth.create_access_token(usuario_dict)
            user.token = token
        
            await BD.CreatUserBD(user)
            
        except Exception as e:
            raise HTTPException(status_code=400, detail=f"Error al crear usuario: {str(e)}")





        
    

    

    





    
  


      