from databases import Database
from src.Service.envirioments import settings
from pydantic import BaseModel,EmailStr
from fastapi import HTTPException


class BD():
        
    User = settings.BD_USER
    Pass = settings.BD_PASSWORD
    db = settings.BD_NAME
    DATABASE_URL = "mysql+aiomysql://"+User+":"+Pass+"@localhost/"+db
    database = Database(DATABASE_URL)
        
        

    async def CreatUserBD(user:BaseModel):
        database = BD.database
        ValidEmail =await BD.valid_emailBD(user.email,database)
        
        if ValidEmail:
            raise HTTPException(
                status_code=400,
                detail="El correo electrónico ya está registrado"
            )
        
        query = """
            INSERT INTO usuario 
            ( estado, nombre, contrasena, correo, token, rol_id) 
            VALUES 
            (:estado, :nombre, :contrasena, :correo, :token, :rol_id)
            """

        await database.execute(
            query,
            {
            "estado": 0,
            "nombre": user.name,
            "contrasena": user.password,  
            "correo": user.email,
            "token": user.token,
            "rol_id": 2
            }
            )
        
    async def valid_emailBD(email: EmailStr, database: Database) -> bool:
        try:
            
            query = "SELECT EXISTS(SELECT 1 FROM usuario WHERE correo = :correo)"
            result = await database.fetch_val(
            query=query,
            values={"correo": email}
            
            )
        
            return bool(result)
        
        except Exception as e:
            raise HTTPException(
            status_code=500,
            detail=f"Error verificando correo: {str(e)}"
        )

    async def valid_UserBD(user: str):
        database = BD.database
        try:
            
            query = "SELECT contrasena,token FROM usuario WHERE correo = :correo"
            result = await database.fetch_one(
            query=query,
            values={"correo": user}
            
            )
        
            return {"password":result["contrasena"],"token":result["token"],"valid_pass":bool(result) }
        
        except Exception as e:
            raise HTTPException(
            status_code=500,
            detail=f"Error verificando correo: {str(e)}"
        )

        


