import os, datetime
from fastapi import Request, FastAPI, status
from gql import gql, Client
from gql.transport.requests import RequestsHTTPTransport
from jinja2 import Template

# configuration
DEBUG = os.environ.get('DEBUG')
PREFIX = "/api" # defined in the reverse proxy

# instantiate the app
app = FastAPI(debug=DEBUG, title="EtherScore-backend", openapi_prefix=PREFIX)


class TheGraph():
    """
    Base class to request TheGraph
    """
    def __init__(self, subgraph_url) -> None:
        self.sample_transport = RequestsHTTPTransport(
			url=subgraph_url,
			verify=True,
			retries=5,
		)
        self.client = client = Client(
			transport=self.sample_transport
		)
        self.template = ""

    def run(self, values={}):
        rendered = Template(self.template).render(values)
        query = gql(rendered)
        return self.client.execute(query)


class UniswapTransactions(TheGraph):
    """
    Get Uniswap transactions for a given wallet address
    """
    def __init__(self) -> None:
        subgraph_url = 'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2'
        super().__init__(subgraph_url)
        self.template ="""
		{
            swaps(orderBy: timestamp, where: { to: "{{ address }}" }) {
                id
                transaction {
                    id
                    timestamp
                }
                pair {
                    token0 {
                        symbol
                    }
                    token1 {
                        symbol
                    }
                }
                to
                sender
            }
		}
		"""


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
    """
    Root endpoint
    """
    return {"message": "EtherScore backend"}

# Healthcheck route
@app.get("/ping", status_code=status.HTTP_200_OK)
async def ping():
    """
    Endpoint for healthcheck
    """
    return str(datetime.datetime.now())

# Retrieve badges and status for a given address
@app.post(path="/badges", status_code=status.HTTP_200_OK)
async def badges(request: Request):
    """
    Retrieve badges and their status for a given address (ex 0x1F653f9d3dD5a0fc61aFC6969e4f07e32Bf4CDe0)
    """
    content = await request.json()
    wallet_address = str(content["wallet_address"])
    uniswap_transactions = UniswapTransactions().run({'address': wallet_address})['swaps']
    print(uniswap_transactions, "size:", len(uniswap_transactions))
    print("User address: " + wallet_address)
    return [badge0, badge1]
