FROM python:3.11-slim

WORKDIR /app

# Instala dependencias del sistema necesarias para compilar y usar MySQL
RUN apt-get update && apt-get install -y \
    gcc \
    libmariadb-dev \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*


COPY pyproject.toml .
COPY app ./app

# Instala uv y las dependencias del proyecto
RUN pip install uv && uv pip install --system -r pyproject.toml

# Expone el puerto para producción
EXPOSE 8000

# Comando de inicio
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
