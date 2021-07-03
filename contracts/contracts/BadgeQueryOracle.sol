// contracts/BadgeQueryOracle.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title BadgeQueryOracle
 * @author Geoffrey Garcia
 * @notice Contract to use to run query on off-chain ressources.
 * @dev The BadgeQueryOracle contract provides basic structures, functions & modifiers that allows to run query on off-chain ressources.
 */
contract BadgeQueryOracle is Ownable {

    using Counters for Counters.Counter;

    // Query structure
    struct Request {
        address caller;                 // the Ethereum address which has requested for the query result
        bool isPending;                 // the status of the query treatment (true if the result is still unknown)
        bytes32 badgeConditionGroupID;  // the ID of the condition group to mint the badge
        string indexer;                 // the service indexing the data (possible values: "thegraph, "covalent")
        string protocol;                // the set/subgraph on the indexer to use (possible values: "uniswap", "compound" ,"aave" ,"ethereum")
        string query;                   // the query to be run
        string queryResult;             // the result of the query
    }

    // Storage of the badge queries
    Counters.Counter private _queryNonce;               // a nonce injected to build the query IDs
    mapping(bytes32 => Request) private _requests;      // the list of queries

    /**
    * @dev See {Ownable-constructor}.
    */
    constructor() Ownable(){
    }

    /**
    * @dev Throws if the result does not match with a previous query request.
    * @param _caller The Ethereum address which has requested for the query result.
    * @param _badgeConditionGroupID The ID of the condition group to mint the badge.
    * @param _requestID The ID of the query.
    */
    modifier onlyExpectedResult(address _caller, bytes32 _badgeConditionGroupID, bytes32 _requestID) {
        // Checking the request identifiers
        Request storage pendingQuery = _requests[_requestID];       
        require((pendingQuery.caller == _caller) && (pendingQuery.badgeConditionGroupID == _badgeConditionGroupID), "BadgeQueryOracle: unexpected request identifiers");
        _;
    }

    /**
    * @dev Throws if the query treatment is not in progress.
    * @param _requestID The ID of the query.
    */
    modifier isPendingQuery(bytes32 _requestID) {
        Request storage query = _requests[_requestID];  
        require(query.isPending, "BadgeQueryOracle: query has already been resolved");
        _;
    }

    /**
    * @notice Function to run a query.
    * @dev Run a query in order to be able to check if a condition to mint a badge is met.
    * @param _caller The Ethereum address which has requested for the query result.
    * @param _badgeConditionGroupID The ID of the condition group to mint the badge.
    * @param _indexer The service indexing the data (possible values: "thegraph, "covalent").
    * @param _protocol The set/subgraph on the indexer to use (possible values: "uniswap", "compound" ,"aave" ,"ethereum").
    * @param _query The query to be run.
    * @return _requestID The ID of the query.
    */
    function runQuery(address _caller, bytes32 _badgeConditionGroupID, string memory _indexer, string memory _protocol, string memory _query) onlyOwner() public returns (bytes32 _requestID) {
        //TODO : remove
        //_queryResult = "51";
        
        // Asking for the query to be run
        _queryNonce.increment();
        _requestID = keccak256(abi.encodePacked(block.timestamp, _caller, _queryNonce.current()));

        // Storing the pending query
        Request storage pendingQuery = _requests[_requestID];
        pendingQuery.caller = _caller;
        pendingQuery.isPending = true;
        pendingQuery.badgeConditionGroupID = _badgeConditionGroupID;
        pendingQuery.indexer = _indexer;
        pendingQuery.protocol = _protocol;
        pendingQuery.query = _query;

        return _requestID;
    }

    /**
    * @notice Function to record a query and its result into the blockchain.
    * @dev Record a query and its result into the blockchain in order to further minting validation.
    * @param _caller The Ethereum address which has requested for the query result.
    * @param _badgeConditionGroupID The ID of the condition group to mint the badge.
    * @param _requestID The ID of the query.
    * @param _queryResult The result of the query.
    */
    function recordQueryResult(address _caller, bytes32 _badgeConditionGroupID, bytes32 _requestID, string memory _queryResult) onlyOwner() onlyExpectedResult(_caller, _badgeConditionGroupID, _requestID) isPendingQuery(_requestID) public {
        // Recording for the query & its result
        Request storage resolvedQuery = _requests[_requestID];
        resolvedQuery.isPending = false;
        resolvedQuery.queryResult = _queryResult;
    }
}
