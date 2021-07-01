import os, datetime, re
import requests
import covalent_api
from pprint import pprint
from fastapi import Request, FastAPI, status
from jinja2 import Template

# configuration
DEBUG = os.environ.get('DEBUG')
PREFIX = "/api" # defined in the reverse proxy

# instantiate the app
app = FastAPI(debug=DEBUG, title="EtherScore-backend", openapi_prefix=PREFIX)

# functon to create a new object from a var classname
def create_class(classname):
    cls = globals()[classname]
    return cls()

# function to use requests.post to make an API call to the subgraph url
def run_query(url, q):
    request = requests.post(url, '', json={'query': q})
    if request.status_code == 200:
        return request.json()
    else:
        raise Exception('Query failed. return code is {}. {}'.format(request.status_code, q))


class TheGraph():
    """
    Base class to request TheGraph
    """
    def __init__(self, subgraph_url) -> None:
        self.subgraph_url = subgraph_url
        self.template = ""

    def run(self, values={}):
        query = Template(self.template).render(values) 
        return run_query(self.subgraph_url, query)['data']


class Covalent():
    """
    Base class to request Covalent API
    """
    def __init__(self, ckey):
        self.session = covalent_api.Session(api_key=ckey)
        self.a = covalent_api.ClassA(self.session)

    def get_holdings(self, wallet_address, skip_nft_metadata):
        # check if he holds one of our nfts
        return self.a.get_token_balances_for_address(1, wallet_address, True, skip_nft_metadata)


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
        number_of_swaps = 0
        res = self.run({'address': address})
        pprint(res)
        if len(res['swaps']) > 0:
            number_of_swaps = len(res['swaps'])
        # TODO: replace 0 indice in next line to use multiple conditions
        badge_passport["conditions"][0]["current"] = number_of_swaps
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
        max_amount = 0
        res = self.run({'address': address})
        if len(res['swaps']) > 0:
            max_amount = res['swaps'][0]['amountUSD']
        # TODO: replace 0 indice in next line to use multiple conditions
        badge_passport["conditions"][0]["current"] = max_amount
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
    "conditions" : 
        [{
        "protocol": "uniswap",
        "description": "number of swaps",
        "target": 50,
        "operator": "gte"
        }]
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
    "conditions":
        [{
        "protocol": "uniswap",
        "description": "max amount swapped",
        "target": 500,
        "operator": "gte"
        }]
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
    defs = badges_definitions.copy()
    pat = re.compile(r"^0x[a-fA-F0-9]{40}$")
    if pat.match(wallet_address):
        print("this is an adress")
        print("User address: " + wallet_address)

        badges_passports = [] # a passport is the definition + the customized information
        for badge in defs:
            # for every badge in the definition list
            mytype = badge['type']
            # create the right object (UniswapTransaction) associated to the badge, to set and verify conditions
            current = create_class(mytype)
            # add it to the passports list
            badges_passports.append(current.generate_badge_passport(wallet_address, badge))
        return badges_passports

    else:
        print("------ no adress")
        pprint(badges_definitions)
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