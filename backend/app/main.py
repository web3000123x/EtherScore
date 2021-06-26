import os, datetime, re
from types import new_class
from fastapi import Request, FastAPI, status
from gql import gql, Client
from gql.transport.requests import RequestsHTTPTransport
from jinja2 import Template

# configuration
DEBUG = os.environ.get('DEBUG')
PREFIX = "/api" # defined in the reverse proxy

# instantiate the app
app = FastAPI(debug=DEBUG, title="EtherScore-backend", openapi_prefix=PREFIX)

def create_class(classname):
    cls = globals()[classname]
    return cls()

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
        query = '/app/queries/uniswap_transactions.ql'
        super().__init__(subgraph_url)
        with open(query, 'r') as f:
            self.template = f.read()
    
    def generate_badge_passport(self, address, badge):
        badge_passport = badge.copy()
        number_of_swaps = len(self.run({'address': address})['swaps'])
        conditions = [{
            "protocol": "uniswap",
            "description": "number of swaps",
            "target": 50,
            "operator": "gte",
            "current": number_of_swaps
        }]
        badge_passport["conditions"] = conditions
        #badge_passport["owned"] = get
        return badge_passport


class UniswapMaxSwapAmount(TheGraph):
    """
    Get Uniswap max amount swapped
    """
    def __init__(self) -> None:
        subgraph_url = 'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2'
        query = '/app/queries/uniswap_max_value_swap.ql'
        super().__init__(subgraph_url)
        with open(query, 'r') as f:
            self.template = f.read()
    
    def generate_badge_passport(self, address, badge):
        badge_passport = badge.copy()
        max_amount = self.run({'address': address})['swaps'][0]['amountUSD']
        conditions = [{
            "protocol": "uniswap",
            "description": "max amount swapped",
            "target": 500,
            "operator": "gte",
            "current": max_amount
        }]
        badge_passport["conditions"] = conditions
        #badge_passport["owned"] = get
        return badge_passport


class CompoundNeverLiquidated(TheGraph):
    """
    Get compound user, number of liquitated
    """
    def __init__(self) -> None:
        subgraph_url = 'https://api.thegraph.com/subgraphs/name/graphprotocol/compound-v2'
        query = '/app/queries/compound_never_liquidated.ql'
        super().__init__(subgraph_url)
        with open(query, 'r') as f:
            self.template = f.read()
    
    def generate_badge_passport(self, address, badge):
        badge_passport = badge.copy()


badge0 = {
    "id" : 0,
    "name": "Badge Number 0",
    "type": "UniswapTransactions",
    "description": "This is the badge 0 description",
    "bonus": "5 collateral covered",
    "owner" : "0x0003893947437",
    "tags": ["uniswap", "experience"],
    "image_url": "https://i.redd.it/rq36kl1xjxr01.png",
}

badge1 = {
    "id" : 1,
    "name": "Badge Number 1",
    "type": "UniswapMaxSwapAmount",
    "description": "This is the badge 1 description",
    "bonus": "another bonus",
    "issuer" : "Uniswap",
    "address" : "0x9888888888999999999",
    "tags": ["uniswap", "transaction"],
    "image_url": "https://i.redd.it/rq36kl1xjxr01.png",
}


# get badges definitions from smart contract
badges_definitions = [badge0, badge1]


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
    Retrieve badges and their status for a given address (ex "0x1F653f9d3dD5a0fc61aFC6969e4f07e32Bf4CDe0")
    """
    content = await request.json()
    try:
        # get the address
        wallet_address = str(content["wallet_address"])
    except:
        return "error parsing POST request"

    pat = re.compile(r"^0x[a-fA-F0-9]{40}$")
    if pat.match(wallet_address):

        print("User address: " + wallet_address)

        badges_passports = [] # a passport is the definition + the customized information
        for badge in badges_definitions:
            # for every badge in the definition list
            mytype = badge['type']
            # create the right object (UniswapTransaction) associated to the badge, to set and verify conditions
            current = create_class(mytype)
            # add it to the passports list
            badges_passports.append(current.generate_badge_passport(wallet_address, badge))
        return badges_passports

    else:
        # return badge definitions
        return badges_definitions


# Retrieve badges held by the address
@app.post(path="/badges-definition", status_code=status.HTTP_200_OK)
async def badges_definition(request: Request):
    """
    Retrieve badges held by the address
    """
    content = await request.json()
    wallet_address = str(content["wallet_address"])
    return badges_definitions