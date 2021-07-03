The BadgeQueryOracle contract provides basic structures, functions & modifiers that allows to run query on off-chain ressources.

# Functions:
- [`constructor()`](#BadgeQueryOracle-constructor--)
- [`runQuery(address _caller, bytes32 _badgeConditionGroupID, string _indexer, string _protocol, string _query)`](#BadgeQueryOracle-runQuery-address-bytes32-string-string-string-)
- [`recordQueryResult(address _caller, bytes32 _badgeConditionGroupID, bytes32 _requestID, string _queryResult)`](#BadgeQueryOracle-recordQueryResult-address-bytes32-bytes32-string-)


# Function `constructor()` {#BadgeQueryOracle-constructor--}
See {Ownable-constructor}.
# Function `runQuery(address _caller, bytes32 _badgeConditionGroupID, string _indexer, string _protocol, string _query) → bytes32 _requestID` {#BadgeQueryOracle-runQuery-address-bytes32-string-string-string-}
Run a query in order to be able to check if a condition to mint a badge is met.

## Parameters:
- `_caller`: The Ethereum address which has requested for the query result.

- `_badgeConditionGroupID`: The ID of the condition group to mint the badge.

- `_indexer`: The service indexing the data (possible values: "thegraph, "covalent").

- `_protocol`: The set/subgraph on the indexer to use (possible values: "uniswap", "compound" ,"aave" ,"ethereum").

- `_query`: The query to be run.

## Return Values:
- _requestID The ID of the query.
# Function `recordQueryResult(address _caller, bytes32 _badgeConditionGroupID, bytes32 _requestID, string _queryResult)` {#BadgeQueryOracle-recordQueryResult-address-bytes32-bytes32-string-}
Record a query and its result into the blockchain in order to further minting validation.

## Parameters:
- `_caller`: The Ethereum address which has requested for the query result.

- `_badgeConditionGroupID`: The ID of the condition group to mint the badge.

- `_requestID`: The ID of the query.

- `_queryResult`: The result of the query.

