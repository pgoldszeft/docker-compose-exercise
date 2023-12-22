import os

import redis
from flask import Flask

app = Flask(__name__)
redis_client = redis.Redis(host=os.getenv("REDIS_HOST", "localhost"), port=6379, decode_responses=True)
service_id = str(redis_client.incr("COUNTER"))

@app.route("/")
def ping():
    return service_id
