# FROM python:3.9-slim

# WORKDIR /app

# COPY requirements.txt .
# RUN pip install -r requirements.txt

# COPY . .

# CMD ["python", "app.py"]

FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . . 
# The line above copies EVERYTHING, including the templates folder
CMD ["python", "app.py"]