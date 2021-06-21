import os, datetime

from fastapi import Request, FastAPI, status

# configuration
DEBUG = os.environ.get('DEBUG')
PREFIX = "/api"

# instantiate the app
app = FastAPI(debug=DEBUG, title="EtherScore-backend", openapi_prefix=PREFIX)

badge0 = {
    "id" : 0,
    "name": "Badge Number 0",
    "description": "This is the badge 0 description",
    "owner" : "Toto",
    "address" : "0x999999999999999999",
    "tags": ["uniswap", "experience"],
    "image_url": "https://i.redd.it/rq36kl1xjxr01.png",
    "conditions": [
        {
            "protocol": "uniswap",
            "rule": "number of swaps",
            "target": 50,
            "current": 10
        }
    ]
}

badge1 = {
    "id" : 1,
    "name": "Badge Number 1",
    "description": "This is the badge 1 description",
    "owner" : "Toto",
    "address" : "0x9888888888999999999",
    "tags": ["uniswap", "transaction"],
    "image_url": "https://i.redd.it/rq36kl1xjxr01.png",
    "conditions": [
        {
            "protocol": "uniswap",
            "rule": "null"
        },
    ]
}

######################################
# Define the different app endpoints #
######################################

# API root
@app.get("/")
async def root():
    return {"message": "EtherScore backend"}

# sanity check route
@app.get("/ping")
async def ping():
    return str(datetime.datetime.now())

# Retrieve badges and status for a given address
@app.post(path="/badges", status_code=status.HTTP_200_OK)
async def badges(request: Request):
    """
    Retrieve badges and status for a given address
    """
    content = await request.json()
    wallet_address = str(content["wallet_address"])
    print("User address: " + wallet_address)
    return [badge0, badge1]
