from fastapi import FastAPI
from src.Routes.route_users import user_route
from src.Database.BD import BD
app = FastAPI(
    title="Api Obvervatorio Vial",
    description="En esta Api se refleja toda la logica del negocio de nuestro proyecto",
    version="1.0.0",
)

@app.on_event("startup")
async def startup():
    database = BD.database 
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    database = BD.database 
    await database.disconnect()

app.include_router(router=user_route)



