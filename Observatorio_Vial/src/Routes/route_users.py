from fastapi import APIRouter
from src.Model.model_user import User_Sign_in
from src.Auth.Auth import auth
from fastapi.security import OAuth2PasswordRequestForm
from fastapi import Depends
from typing import Annotated
from passlib.context import CryptContext
user_route = APIRouter()


@user_route.post("/Sign in",tags=["Usuario"],summary="Registrar Usuario", description="Este edpoint nos permite registrar el usuario")
async def register_user(user:User_Sign_in):
    await User_Sign_in.create_user(user)
    return  {"message": "Registro exitoso"}

@user_route.post("/login",tags=["Usuario"],summary="Login de Usuario",description="En este edpoint nos permite dar acceso acceso a el usuario para la navegacion")
async def login_user(form_data: OAuth2PasswordRequestForm = Depends()):
    Value =await auth.Auth_user(form_data.username,form_data.password)
    
    token:str = Value['Response']
    return {'message': 'Inicio de ssesion','access_token':token,'token_type':'bearer'}
   

@user_route.get("/",tags=["Usuario"],summary="Obtener Usuarios")
def get_user(token: str = Depends(auth.oauth2_bear)):
        
    return token



