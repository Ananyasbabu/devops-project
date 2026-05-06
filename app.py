from flask import Flask, jsonify, render_template
import os
import time
import socket

app = Flask(__name__)

# Track data for the UI
logs = []

def add_log(message):
    timestamp = time.strftime("%H:%M:%S")
    # We also include the Hostname to show which Kubernetes Pod is answering
    hostname = socket.gethostname()
    logs.append({"time": timestamp, "msg": message, "host": hostname})

@app.route('/')
def home():
    add_log("Home page accessed")
    return render_template('index.html', hostname=socket.gethostname())

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "pod": socket.gethostname()}), 200

@app.route('/api/logs')
def get_logs():
    return jsonify(logs[::-1]) # Return newest logs first

@app.route('/crash')
def crash():
    add_log("CRASH TRIGGERED! System exiting...")
    # Delay slightly so the log can be seen/sent before death
    os._exit(1)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)