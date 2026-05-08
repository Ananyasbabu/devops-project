# from flask import Flask, jsonify, render_template
# import os
# import time
# import socket

# app = Flask(__name__)

# # Track data for the UI
# logs = []

# def add_log(message):
#     timestamp = time.strftime("%H:%M:%S")
#     # We also include the Hostname to show which Kubernetes Pod is answering
#     hostname = socket.gethostname()
#     logs.append({"time": timestamp, "msg": message, "host": hostname})

# @app.route('/')
# def home():
#     add_log("Home page accessed")
#     return render_template('index.html', hostname=socket.gethostname())

# @app.route('/health')
# def health():
#     return jsonify({"status": "healthy", "pod": socket.gethostname()}), 200

# @app.route('/api/logs')
# def get_logs():
#     return jsonify(logs[::-1]) # Return newest logs first

# @app.route('/crash')
# def crash():
#     add_log("CRASH TRIGGERED! System will restart in 2 seconds...")
#     # We return a message to the browser FIRST
#     # So the user knows what happened before the process exits
#     response = "<h1>Crash Triggered!</h1><p>Kubernetes will heal this in a few seconds. Please refresh the home page manually.</p>"
    
#     # We use a timer to kill the app AFTER the browser gets the message
#     import threading
#     threading.Timer(2.0, lambda: os._exit(1)).start()
    
#     return response

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000)



from flask import Flask, jsonify, render_template
import os
import time
import socket

app = Flask(__name__)

# System Stats
START_TIME = time.time()
REQUEST_COUNT = 0
logs = []

def add_log(message):
    timestamp = time.strftime("%H:%M:%S")
    hostname = socket.gethostname()
    logs.insert(0, {"time": timestamp, "msg": message, "host": hostname})
    if len(logs) > 10: logs.pop()

@app.route('/')
def home():
    global REQUEST_COUNT
    REQUEST_COUNT += 1
    uptime = round(time.time() - START_TIME, 2)
    return render_template('index.html', 
                           hostname=socket.gethostname(), 
                           uptime=uptime, 
                           requests=REQUEST_COUNT)

@app.route('/api/stats')
def stats():
    return jsonify({
        "uptime": f"{round(time.time() - START_TIME, 2)}s",
        "requests": REQUEST_COUNT,
        "pod": socket.gethostname(),
        "logs": logs
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

@app.route('/crash')
def crash():
    # Graceful exit to let the browser see the logs
    import threading
    threading.Timer(1.0, lambda: os._exit(1)).start()
    return "<h1>Pod Crashing...</h1><p>Kubernetes will restart this soon.</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)