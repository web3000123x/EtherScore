import os, datetime

from fastapi import Request, FastAPI

# configuration
DEBUG = os.environ.get('DEBUG')

# instantiate the app
app = FastAPI(debug=DEBUG, title="EtherScore-backend")

######################################
# Define the different app endpoints #
######################################

# sanity check route
@app.get("/ping")
def ping():
    return str(datetime.datetime.now())
