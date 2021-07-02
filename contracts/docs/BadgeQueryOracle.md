The BadgeQueryOracle contract provides basic structures, functions & modifiers that allows to run query on off-chain ressources.

# Functions:
- [`constructor()`](#BadgeQueryOracle-constructor--)
- [`runQuery(address _caller, uint256 _badgeConditionGroupID, string _indexer, string _protocol, string _query)`](#BadgeQueryOracle-runQuery-address-uint256-string-string-string-)
- [`recordQueryResult(address _caller, uint256 _badgeConditionGroupID, uint256 _requestID, string _queryResult)`](#BadgeQueryOracle-recordQueryResult-address-uint256-uint256-string-)

# Events:
- [`QueryRequest(uint256 _requestID, string _indexer, string _protocol, string _query)`](#BadgeQueryOracle-QueryRequest-uint256-string-string-string-)
- [`QueryResult(uint256 _requestID, string _queryResult)`](#BadgeQueryOracle-QueryResult-uint256-string-)

# Function `constructor()` {#BadgeQueryOracle-constructor--}
See {Ownable-constructor}.
# Function `runQuery(address _caller, uint256 _badgeConditionGroupID, string _indexer, string _protocol, string _query) → uint256 _requestID` {#BadgeQueryOracle-runQuery-address-uint256-string-string-string-}
Run a query in order to be able to check if a condition to mint a badge is met.

## Parameters:
- `_caller`: The Ethereum address which has requested for the query result.

- `_badgeConditionGroupID`: The ID of the condition group to mint the badge.

- `_indexer`: The service indexing the data (possible values: "thegraph").

- `_protocol`: The set/subgraph on the indexer to use (possible values: "uniswap", "compound").

- `_query`: The query to be run.

## Return Values:
- _requestID The ID of the query.
# Function `recordQueryResult(address _caller, uint256 _badgeConditionGroupID, uint256 _requestID, string _queryResult)` {#BadgeQueryOracle-recordQueryResult-address-uint256-uint256-string-}
Record a query and its result into the blockchain in order to further minting validation.

## Parameters:
- `_caller`: The Ethereum address which has requested for the query result.

- `_badgeConditionGroupID`: The ID of the condition group to mint the badge.

- `_requestID`: The ID of the query.

- `_queryResult`: The result of the query.

# Event `QueryRequest(uint256 _requestID, string _indexer, string _protocol, string _query)` {#BadgeQueryOracle-QueryRequest-uint256-string-string-string-}
Event emitted to request for a query to be run for BadgeToken minting.

## Parameters:
- `_requestID`: The ID of the query.

- `_indexer`: The service indexing the data (possible values: "thegraph").

- `_protocol`: The set/subgraph on the indexer to use (possible values: "uniswap", "compound").

- `_query`: The query to run.
# Event `QueryResult(uint256 _requestID, string _queryResult)` {#BadgeQueryOracle-QueryResult-uint256-string-}
Event emitted fter the query and its result have been record into the blockchain for BadgeToken minting.

## Parameters:
- `_requestID`: The ID of the query.

- `_queryResult`: The result of the query.
