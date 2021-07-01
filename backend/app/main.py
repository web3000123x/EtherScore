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
        nb_liquidations = None
        sumBorrowed = None
        res = self.run({'address': address})
        if res['account'] != None :
            nb_liquidations = res['account']["countLiquidated"]
            sumBorrowed = res['account']["totalBorrowValueInEth"]
        # TODO: replace 0 indice in next line to use multiple conditions
        badge_passport["conditions"][0]["current"] = sumBorrowed
        badge_passport["conditions"][1]["current"] = nb_liquidations
        #badge_passport["owned"] = get
        return badge_passport

class CompoundLiquidator(TheGraph):
    """
    Get compound user, number of liquitated
    """
    def __init__(self) -> None:
        subgraph_url = 'https://api.thegraph.com/subgraphs/name/graphprotocol/compound-v2'
        query = '/app/queries/compound_liquidator.ql'
        super().__init__(subgraph_url)
        with open(query, 'r') as f:
            self.template = f.read()
    
    def generate_badge_passport(self, address, badge):
        badge_passport = badge.copy()
        nb_liquidations = None
        res = self.run({'address': address})
        if res['account'] != None :
            nb_liquidations = res['account']["countLiquidator"]
        # TODO: replace 0 indice in next line to use multiple conditions
        badge_passport["conditions"][0]["current"] = nb_liquidations
        #badge_passport["owned"] = get
        return badge_passport


badge0 = {
    "id" : 0,
    "name": "Ze Trader",
    "type": "UniswapTransactions",
    "description": "Ze Trader is not a fan of centralized exchanges",
    "bonus": "5 collateral covered",
    "issuer" : "Uniswap",
    "address" : "0x0003893947437",
    "tags": ["uniswap", "experience"],
    "image_url": "https://imgflip.com/s/meme/Money-Money.jpg",
    "conditions" : 
        [{
        "protocol": "uniswap",
        "description": "number of swaps",
        "target": 50,
        "operator": ">="
        }]
}

badge1 = {
    "id" : 1,
    "name": "Ze Whale",
    "type": "UniswapMaxSwapAmount",
    "description": "Ze Whale is swimming in the DeFi ecosystem",
    "bonus": "another bonus",
    "issuer" : "Uniswap",
    "address" : "0x9888888888999999999",
    "tags": ["uniswap", "transaction"],
    "image_url": "https://assets.newatlas.com/dims4/default/572b515/2147483647/strip/true/crop/1620x1080+150+0/resize/1200x800!/quality/90/?url=http%3A%2F%2Fnewatlas-brightspot.s3.amazonaws.com%2Farchive%2Fblue-whale-1.jpg",
    "conditions":
        [{
        "protocol": "uniswap",
        "description": "max amount swapped",
        "target": 10000,
        "operator": ">="
        }]
}

badge2 = {
    "id" : 2,
    "name": "Ze Borrower",
    "type": "CompoundNeverLiquidated",
    "description": "Ze Borrower does not fear margin calls",
    "bonus": "another bonus",
    "issuer" : "Compound",
    "address" : "0x9888888888999999999",
    "tags": ["compound", "liquidation"],
    "image_url": "https://i.pinimg.com/originals/33/e0/0b/33e00b57d15daaece29e29e9b475683f.png",
    "conditions":
        [{
        "protocol": "compound",
        "description": "ETH value borrowed",
        "target": 0,
        "operator": ">"
        },
        {
        "protocol": "compound",
        "description": "number of liquidations",
        "target": 0,
        "operator": "=="
        }]
}

badge3 = {
    "id" : 3,
    "name": "Ze Shark",
    "type": "CompoundLiquidator",
    "description": "Ze Shark is a sociopath sustaining the network",
    "bonus": "another bonus",
    "issuer" : "Compound",
    "address" : "0x9888888888999999999",
    "tags": ["compound", "liquidator"],
    "image_url": "https://media.istockphoto.com/photos/shark-swimming-towards-the-surface-with-mouth-open-picture-id1160436763?b=1&k=6&m=1160436763&s=170667a&w=0&h=Vb8G06Wln7t1oDzdtKLTWh0LkCRT4n4wo2GD6RiBoX4=",
    "conditions":
        [
        {
        "protocol": "compound",
        "description": "number of liquidations as liquidator",
        "target": 10,
        "operator": ">="
        }]
}

# get badges definitions from smart contract
badges_definitions = [badge0, badge1, badge2, badge3]


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