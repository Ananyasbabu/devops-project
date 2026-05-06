from flask import Flask, jsonify
import os
import time

app = Flask(__name__)

# simple log storage
logs = []

def add_log(message):
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
    logs.append(f"{timestamp} - {message}")

# Home route
@app.route('/')
def home():
    add_log("Home page accessed")
    return "Application Running 4 is running ✅"

# Health check (VERY IMPORTANT)
@app.route('/health')
def health():
    return "OK", 200

# Logs route
@app.route('/logs')
def get_logs():
    return jsonify(logs)

# Crash simulation route (for demo 🔥)
@app.route('/crash')
def crash():
    add_log("Application crash simulated!")
    os._exit(1)  # force crash

if __name__ == '__main__':
    add_log("Application started")
    app.run(host='0.0.0.0', port=5000)