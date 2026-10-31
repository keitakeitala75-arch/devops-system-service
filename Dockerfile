FROM python:3.14-slim

WORKDIR /app

# Create a non-root user
RUN useradd --create-home appuser

# Install application dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY app/ ./app/

# Give the application user ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

EXPOSE 5000

CMD ["python", "app/app.py"]
