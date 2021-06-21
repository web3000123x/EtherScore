import os, datetime, json

from fastapi import Request, FastAPI

# configuration
DEBUG = os.environ.get('DEBUG')

# instantiate the app
app = FastAPI(debug=DEBUG, title="EtherScore-backend")

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
            "rule": "null"
        },
        {
            "protocol": "uniswap",
            "rule": "null"
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
        {
            "protocole": "uniswap",
            "rule": "null"
        }
    ]
}

######################################
# Define the different app endpoints #
######################################

# sanity check route
@app.get("/ping")
def ping():
    return str(datetime.datetime.now())

# List all existing badges
@app.get("/all_badges")
def all_badges():
    return [badge0, badge1]

# Retrieve claimable badges for a given address
@app.post("/claimable_badges")
async def claimable_badges(request: Request):
    content = await request.json()
    wallet_address = str(content["wallet_address"])
    print("User address: " + wallet_address)
    id_badge0 = 0
    return [id_badge0]
