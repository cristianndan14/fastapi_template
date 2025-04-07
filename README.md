# 🚀 FastAPI + uv + Docker + MySQL + Testing + Alembic

Plantilla moderna, ligera y productiva para construir APIs con **FastAPI**, utilizando un entorno gestionado con [`uv`](https://github.com/astral-sh/uv), base de datos **MySQL**, migraciones con **Alembic**, y herramientas de desarrollo listas para producción y testing.

---

## 🔧 Herramientas incluidas

| Herramienta     | Propósito |
|-----------------|-----------|
| **FastAPI**     | Framework web asincrónico rápido y moderno para construir APIs. |
| **Uvicorn**     | Servidor ASGI de alto rendimiento, ideal para FastAPI. |
| **uv**          | Gestor de entornos y dependencias ultrarrápido, compatible con `pip`, `venv` y `pyproject.toml`. |
| **SQLAlchemy**  | ORM moderno compatible con asincronía. |
| **MySQL**       | Base de datos relacional. Se ejecuta mediante `docker-compose`. |
| **Alembic**     | Herramienta de migraciones para SQLAlchemy. |
| **pydantic-settings** | Gestión de configuración basada en `.env` usando Pydantic. |
| **pytest**      | Framework para testing. |
| **pytest-cov**  | Reporte de cobertura de tests. |
| **ruff**        | Linter ultrarrápido compatible con el ecosistema Python. |
| **mypy**        | Checker estático de tipos para Python. |
| **Docker**      | Contenedor para empaquetar tu aplicación con todo su entorno listo para producción. |
| **Makefile**    | Automatización de tareas frecuentes para desarrollo local. |

---

## 📁 Estructura del proyecto

```
fastapi_uv_project/
├── app/
│   ├── main.py              # Punto de entrada FastAPI
│   ├── config.py            # Configuración basada en Pydantic
│   ├── db.py                # Conexión a la base de datos MySQL
│   ├── models.py            # Declaración de modelos ORM
│   ├── crud.py              # Operaciones CRUD encapsuladas
│   └── schemas.py           # Esquemas de entrada/salida con Pydantic
├── tests/
│   └── test_main.py         # Test básico del endpoint raíz
├── alembic/                 # Migraciones de base de datos
├── pyproject.toml           # Dependencias del proyecto
├── Dockerfile               # Imagen Docker lista para producción
├── docker-compose.yml       # Base de datos + API
├── Makefile                 # Comandos útiles para desarrollo
├── .env                     # Variables de entorno
├── .gitignore
└── README.md
```

---

## ⚙️ Uso rápido

### 1. Crear entorno virtual con `uv`

```bash
uv venv
```

### 2. Instalar dependencias

```bash
uv pip install -r pyproject.toml --extra dev
```

### 3. Levantar el entorno completo con Docker

```bash
make dev
```

Visita: [http://localhost:8000/docs](http://localhost:8000/docs)

---

## 🧪 Testing y herramientas

- Ejecutar tests: `make test`
- Ver cobertura: `make cov`
- Lint del código: `make lint`
- Verificación de tipos: `make typecheck`

---

## 🐳 Uso con Docker

### Levantar el stack completo (API + MySQL)

```bash
make dev
```

### Migraciones con Alembic

1. Inicializar alembic:
```bash
alembic init alembic
```

2. Configurar `alembic.ini` y `env.py`:
   - Reemplazar la URL de conexión con `settings.DATABASE_URL`
   - Importar y usar tus modelos desde `app.models`

3. Crear migración:
```bash
alembic revision --autogenerate -m "init"
```

4. Aplicar migración:
```bash
alembic upgrade head
```

---

## 🧱 Ejemplo de Modelo + CRUD

### Modelo
```python
# app/models.py
from sqlalchemy import Column, Integer, String
from app.db import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(length=100), nullable=False)
    email = Column(String(length=100), unique=True, index=True, nullable=False)
```

### Esquemas
```python
# app/schemas.py
from pydantic import BaseModel

class UserCreate(BaseModel):
    name: str
    email: str

class UserRead(UserCreate):
    id: int

    class Config:
        orm_mode = True
```

### CRUD
```python
# app/crud.py
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models import User
from app.schemas import UserCreate

async def create_user(db: AsyncSession, user: UserCreate) -> User:
    db_user = User(**user.dict())
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user

async def get_users(db: AsyncSession):
    result = await db.execute(select(User))
    return result.scalars().all()
```

### Endpoint
```python
# app/main.py
from fastapi import FastAPI, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.db import get_async_session
from app import crud, schemas

app = FastAPI()

@app.post("/users", response_model=schemas.UserRead)
async def create_user(user: schemas.UserCreate, db: AsyncSession = Depends(get_async_session)):
    return await crud.create_user(db, user)

@app.get("/users", response_model=list[schemas.UserRead])
async def list_users(db: AsyncSession = Depends(get_async_session)):
    return await crud.get_users(db)
```

---

## 🧠 Casos de uso recomendados

- Microservicios para arquitecturas distribuidas
- APIs internas para productos
- Prototipado rápido de servicios REST
- Aplicaciones asincrónicas de alto rendimiento
- Backends para sistemas frontend o móviles
- Servicios persistentes sobre bases de datos relacionales

---

## 📌 Requisitos

- Python 3.10 o superior
- [`uv`](https://github.com/astral-sh/uv) instalado (`pip install uv`)
- Docker + Docker Compose
- Make (en sistemas Unix)

---

## 🧹 Buenas prácticas

- Separar deps de producción y desarrollo (`--extra dev`)
- Usar `ruff` + `mypy` como CI local
- Alembic para control de versiones de la base de datos
- Agregar `.env` para configuración sensible
- Tests con base de datos en memoria para velocidad

---

## 📬 Feedback

¿Tenés sugerencias o querés extender esta plantilla con JWT, OAuth, Redis o más? Aceptamos ideas.

---

> Plantilla mantenida por [cristianndan14](https://github.com/cristianndan14)
