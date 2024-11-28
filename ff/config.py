import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    def __init__(self, instance_path):
        self.FLASK_RUN_PORT = os.getenv('FLASK_RUN_PORT', 5000)
        self.SECRET_KEY = os.getenv('FLASK_SECRET_KEY', 'dev')
        self.DATABASE = os.path.join(instance_path, 'ff.sqlite')
