# Etapa 1: Base & Build
FROM python:3.13-slim AS base
WORKDIR /app

# Instalar uv para la gestión de dependencias
RUN pip install --no-cache-dir uv

# Copiar definicion de dependencias e instalarlas
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev

# Etapa 2: Desarrollo (dev)
FROM base AS dev
COPY . .
EXPOSE 3000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "3000", "--reload"]

# Etapa 3: Producción (prod)
FROM python:3.13-slim AS prod
WORKDIR /app
ENV PATH="/app/.venv/bin:$PATH"

COPY --from=base /app/.venv /app/.venv
COPY app ./app

EXPOSE 3000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "3000"]
