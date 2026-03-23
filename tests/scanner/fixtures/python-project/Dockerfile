FROM python:3.11-slim as builder

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

EXPOSE 8000

# TODO: Add non-root user for security
# TODO: Add healthcheck instruction

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
