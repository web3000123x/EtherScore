from web3 import Web3
import json

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))
print(w3.eth.blockNumber)

with open("BadgeDefinitionFactory.json") as f:
    abi_json = json.load(f)
abi = abi_json["abi"]


address = '0xCfEB869F69431e42cdB54A4F4f105C19C080A601'

contract = w3.eth.contract(address=address, abi=abi)

print(contract.functions.name().call())
