// contracts/BadgeTokenFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "./BadgeDefinitionFactory.sol";
import "./BadgeQueryOracle.sol";

/**
 * @title BadgeTokenFactory
 * @author Geoffrey Garcia
 * @notice Contract to use to mint and to transfer (if applicable based on associated BadgeDefinition) BadgeToken that are ERC721 tokens.
 * @dev The BadgeTokenFactory contract provides basic structures, functions & modifiers that allows to manage BadgeToken as ERC721 token.
 */
contract BadgeTokenFactory is BadgeFactory {

    using Counters for Counters.Counter;

    /**
    * @notice Event emitted to request for a query to be run.
    * @dev Event emitted to request for a query to be run for BadgeToken minting.
    * @param _requestID The ID of the query.
    * @param _indexer The service indexing the data (possible values: "thegraph, "covalent").
    * @param _protocol The set/subgraph on the indexer to use (possible values: "uniswap", "compound" ,"aave" ,"ethereum").
    * @param _query The query to run.
    */
    event QueryRequest(bytes32 _requestID, string _indexer, string _protocol, string _query);

    /**
    * @notice Event emitted after the query and its result have been record into the blockchain.
    * @dev Event emitted fter the query and its result have been record into the blockchain for BadgeToken minting.
    * @param _requestID The ID of the query.
    * @param _queryResult The result of the query.
    */
    event QueryResultReceived(bytes32 _requestID, string _queryResult);

    /**
    * @notice Event emitted when a BadgeToken is ready to be minted.
    * @dev Event emitted when a BadgeToken is ready to be minted.
    * @param _caller The Ethereum address which has requested for the right to mint the token.
    * @param _badgeDefinitionId The ID of BadgeDefinition associated to this BadgeToken.
    */
    event BadgeTokenReady(address _caller, uint _badgeDefinitionId);

    /**
    * @notice Event emitted after a BadgeToken minting.
    * @dev Event emitted after a BadgeToken minting.
    * @param _badgeTokenId The ID of the BadgeToken.
    * @param _originalOwner The Ethereum address of the user that has minted the token.
    */
    event NewBadgeToken(uint _badgeTokenId, address _originalOwner);

    // Badge token structure
    struct BadgeToken {
        uint badgeDefinitionId;                                 // the ID of BadgeDefinition associated to this BadgeToken
        address originalOwner;                                  // the Ethereum address of the user that has minted the token
        string[maxNumberOfAttributionConditions] specialValues; // the special value associated with this badge (optional)
    }

    // Pending minting structure
    struct PendingMinting {
        address caller;                                // the Ethereum address which has requested for the query result
        uint badgeDefinitionId;                        // the ID of BadgeDefinition associated to the BadgeToken the user want to mint
        uint numberOfConditions;                       // the number of conditions that have to be evaluated through as many queries
        mapping (uint => bytes32) _queryIndex;            // the IDs of the queries
        mapping (bytes32 => bool) _pendingQueryStatus;    // the current status of the queries (true if pending)
        mapping (bytes32 => string) _queryResult;         // the results of the queries (usable only if associated _pendingQueryStatus value is false)
        mapping (bytes32 => string) _evaluationOperator;  // the operator allowing to compare the query return
        mapping (bytes32 => string) _evaluationCondition; // the value to compare with the query result
    }

    // Storage of the badge tokens
    BadgeToken[] private _badgeTokens;                              // BadgeToken storage
    mapping(address => mapping(uint => uint)) private _ownedBadges; // List of BadgeToken IDs per owner per BadgeDefinition
    string badgeTokenSymbol = "BTO";                                // Symbol of the ERC721 tokens of the BadgeToken

    // Storage of the badge minting
    Counters.Counter private _mintingNonce;                                     // a nonce injected to build the ID of the condition group to mint the badge
    mapping(bytes32 => PendingMinting) private _pendingMintings;                // the list of pending badge mintings
    mapping(address => mapping(uint => bytes32)) private _pendingMintingBadges; // List of pending badge mintings per owner per BadgeDefinition
    mapping(bytes32 => bytes32) private _pendingQueries;                        // the list of pending queriesn

    // Reference to the BadgeDefinitionFactory contract allowing to manage BadgeDefinition
    BadgeDefinitionFactory badgeDefinitionFactory;
    // Reference to the BadgeQueryOracle contract allowing to run query on off-chain ressources
    BadgeQueryOracle badgeQueryOracle;

    /**
    * @dev See {ERC721-constructor}.
    * @param _badgeDefinitionFactoryAddress The Ethereum address of the BadgeDefinitionFactory contract allowing to manage BadgeDefinition.
    */
    constructor(address _badgeDefinitionFactoryAddress) BadgeFactory("BadgeToken", badgeTokenSymbol) {
        // Linking this contract with the already deployed one BadgeDefinitionFactory
        badgeDefinitionFactory = BadgeDefinitionFactory(_badgeDefinitionFactoryAddress);
        // Linking this contract with a freshly instantiated BadgeQueryOracle
        badgeQueryOracle = new BadgeQueryOracle();
    }

    /**
    * @dev Throws if the badge is already owned.
    * @param _badgeDefinitionId The ID of BadgeDefinition associated to this BadgeToken.
    */
    modifier notOwned(uint _badgeDefinitionId) {
        require(_ownedBadges[_msgSender()][_badgeDefinitionId] == 0, string(abi.encodePacked(badgeTokenSymbol, ": badge already owned")));
        //TODO: check orignalOwner instead?
        _;
    }

    /**
    * @dev Throws if the badge minting process is already in progress.
    * @param _badgeDefinitionId The ID of BadgeDefinition associated to this BadgeToken.
    */
    modifier isNotPendingMinting(uint _badgeDefinitionId) {
        require(_pendingMintingBadges[_msgSender()][_badgeDefinitionId] == 0, string(abi.encodePacked(badgeTokenSymbol, ": badge already in minting process")));
        _;
    }

    /**
    * @dev Throws if the badge minting process is not in progress.
    * @param _badgeDefinitionId The ID of BadgeDefinition associated to this BadgeToken.
    */
    modifier isPendingMinting(uint _badgeDefinitionId) {
        require(_pendingMintingBadges[_msgSender()][_badgeDefinitionId] != 0, string(abi.encodePacked(badgeTokenSymbol, ": badge not in minting process")));
        _;
    }

    /**
    * @notice Function to mint a BadgeToken as ERC721 tokens.
    * @dev Creates & store a BadgeToken.
    * @param _badgeDefinitionId The ID of BadgeDefinition associated to this BadgeToken.
    */
    function requestBadgeTokenMinting(uint _badgeDefinitionId) notOwned(_badgeDefinitionId) isNotPendingMinting(_badgeDefinitionId) public {
        // Creating for the penting minting
        _mintingNonce.increment();
        bytes32 badgeConditionGroupID = keccak256(abi.encodePacked(block.timestamp, _msgSender(), _mintingNonce.current()));

        // Add the badge minting to the ones asked by the user
        _pendingMintingBadges[_msgSender()][_badgeDefinitionId] = badgeConditionGroupID;

        // Storing for the penting minting
        PendingMinting storage pendingMinting = _pendingMintings[badgeConditionGroupID];
        pendingMinting.caller = _msgSender();

        // Get the BadgeAttributionCondition list associated to this BadgeDefinition
        BadgeAttributionCondition[maxNumberOfAttributionConditions] memory badgeAttributionCondition;
        uint numberOfConditions = 0;
        (numberOfConditions, badgeAttributionCondition) = badgeDefinitionFactory.getBadgeDefinitionAttributionCondition(_badgeDefinitionId);
        pendingMinting.numberOfConditions = numberOfConditions;

        // Check for every condition in the list
        for(uint i=0; i < numberOfConditions; i++){
            // Ask the Oracle to obtain the result of the query
            bytes32 requestID = badgeQueryOracle.runQuery(_msgSender(), badgeConditionGroupID, badgeAttributionCondition[i].indexer, badgeAttributionCondition[i].protocol, badgeAttributionCondition[i].query);
            
            // Asking for the query to be run
            emit QueryRequest(requestID, badgeAttributionCondition[i].indexer, badgeAttributionCondition[i].protocol, badgeAttributionCondition[i].query);
            
            // Store the references & status of the query
            _pendingQueries[requestID] = badgeConditionGroupID;
            pendingMinting._queryIndex[i] = requestID;
            pendingMinting._pendingQueryStatus[requestID] = true;
            pendingMinting._evaluationOperator[requestID] = badgeAttributionCondition[i].operator;
            pendingMinting._evaluationCondition[requestID] = badgeAttributionCondition[i].condition;
        }
    }

    /**
    * @notice Function to get the result of a query.
    * @dev Store the result of the query then ask for the Oracle to write it into the blockchain.
    * @param _requestID The ID of the query.
    * @param _queryResult The result of the query.
    */
    function updateBadgeTokenMinting(bytes32 _requestID, string memory _queryResult) public {
        bytes32 badgeConditionGroupID = _pendingQueries[_requestID];
        require(badgeConditionGroupID != 0, string(abi.encodePacked(badgeTokenSymbol, ": wrong request ID(", _requestID, ") badgeConditionGroupID:", badgeConditionGroupID)));

        // Storing the result
        PendingMinting storage pendingMinting = _pendingMintings[badgeConditionGroupID];
        pendingMinting._pendingQueryStatus[_requestID] = false;
        pendingMinting._queryResult[_requestID] = _queryResult;

        // Sending the result to the Oracle
        badgeQueryOracle.recordQueryResult(pendingMinting.caller, badgeConditionGroupID, _requestID, _queryResult);

        // Telling the query has been recorded
        emit QueryResultReceived(_requestID, _queryResult);

        // Evaluating overall minting process status
        bool evaluationResult = false;
        for(uint i=0; (i < pendingMinting.numberOfConditions) && (evaluationResult == false); i++){
            // Retrieving another query ID
            bytes32 requestID = pendingMinting._queryIndex[i];
            
            // Evaluate if the condition is met
            evaluationResult = pendingMinting._pendingQueryStatus[requestID];
        }

        // Emetting a signal if all the queries have been run
        if(evaluationResult == false){
            emit BadgeTokenReady(pendingMinting.caller, pendingMinting.badgeDefinitionId);
        }
    }

    /**
    * @notice Function to mint a BadgeToken as ERC721 tokens.
    * @dev Creates & store a BadgeToken.
    * @param _badgeDefinitionId The ID of BadgeDefinition associated to this BadgeToken.
    * @return _badgeTokenId The ID of the new BadgeToken.
    */
    function mintBadgeToken(uint _badgeDefinitionId) notOwned(_badgeDefinitionId) isPendingMinting(_badgeDefinitionId) public returns (uint _badgeTokenId) {
        // Identifying the badge the user want to mint
        bytes32 badgeConditionGroupID = _pendingMintingBadges[_msgSender()][_badgeDefinitionId];
        PendingMinting storage pendingMinting = _pendingMintings[badgeConditionGroupID];
        require(_msgSender() == pendingMinting.caller, string(abi.encodePacked(badgeTokenSymbol, ": not the user who has requested the token")));

        string[maxNumberOfAttributionConditions] memory _specialValues;
        require(_assessAttributionCondition(pendingMinting, _specialValues), string(abi.encodePacked(badgeTokenSymbol, ": attempt to mint a token without fullfilling the attribution conditions to get it")));
        
        // Storing the BadgeToken
        _badgeTokens.push(BadgeToken({ badgeDefinitionId: _badgeDefinitionId, originalOwner: _msgSender(), specialValues: _specialValues}));
        
        // Getting the ID of the new BadgeToken
        // uint badgeTokenId = _badgeTokens.length - 1;
        uint badgeTokenId = _badgeTokens.length;

        // Add the badge to the ones owned by the user
        _ownedBadges[_msgSender()][_badgeDefinitionId] = badgeTokenId;

        // Minting the BadgeToken
        _safeMint(_msgSender(), badgeTokenId);

        // Removing the stored pending badge minting
        for(uint i=0; i < pendingMinting.numberOfConditions; i++){
            bytes32 requestID = pendingMinting._queryIndex[i];
            delete _pendingQueries[requestID];
            delete pendingMinting._pendingQueryStatus[requestID];
            delete pendingMinting._queryResult[requestID];
            delete pendingMinting._evaluationOperator[requestID];
            delete pendingMinting._evaluationCondition[requestID];
            delete pendingMinting._queryIndex[i];
        }
        delete _pendingMintingBadges[_msgSender()][_badgeDefinitionId];
        delete _pendingMintings[badgeConditionGroupID];

        // Emit the appropriate event
        emit NewBadgeToken(badgeTokenId, _msgSender());

        return badgeTokenId;
    }

    /**
    * @notice Function to test if the badge produced using a BadgeDefinition can be mint.
    * @dev Check if the conditions to mint the badge are met.
    * @param _pendingMinting The pending badge minting structure.
    * @param _specialValues The special values to be stored (optional).
    * @return _evaluationResult The result of the test.
    */
    function _assessAttributionCondition(PendingMinting storage _pendingMinting, string[maxNumberOfAttributionConditions] memory _specialValues) private view returns (bool _evaluationResult) {
        _evaluationResult = true;

        // Check for every condition in the list
        for(uint i=0; (i < _pendingMinting.numberOfConditions) && (_evaluationResult == true); i++){
            // Retrieving the query ID
            bytes32 requestID = _pendingMinting._queryIndex[i];
            
            // Evaluate if the condition is met
            _evaluationResult = _evaluateCondition(_pendingMinting._queryResult[requestID], _pendingMinting._evaluationOperator[requestID], _pendingMinting._evaluationCondition[requestID], _specialValues[i]);
        } 

        return _evaluationResult;
    }

    /**
    * @notice Function to evaluate a condition.
    * @dev Check if a condition to mint a badge is met.
    * @param _queryResult The result of the query.
    * @param _operator The operator allowing to compare the query return.
    * @param _condition The value to compare with the query result.
    * @param _specialValue The special value to be stored (optional).
    * @return _evaluationResult The result of the test.
    */
    function _evaluateCondition(string memory _queryResult, string memory _operator, string memory _condition, string memory _specialValue) private pure returns (bool _evaluationResult) {
        _evaluationResult = false;

        bytes32 operatorHash = keccak256(bytes(_operator));

        // Evaluate the query return
        if(operatorHash == keccak256(bytes("<"))){
            _evaluationResult = stringToUint(_queryResult) < stringToUint(_condition);
        } else{
            if(operatorHash == keccak256(bytes("<="))){
                _evaluationResult = stringToUint(_queryResult) <= stringToUint(_condition);
            } else{
                if(operatorHash == keccak256(bytes(">"))){
                    _evaluationResult = stringToUint(_queryResult) > stringToUint(_condition);
                } else{
                    if(operatorHash == keccak256(bytes(">="))){
                        _evaluationResult = stringToUint(_queryResult) >= stringToUint(_condition);
                        // _evaluationResult = false;
                    } else{
                        if(operatorHash == keccak256(bytes("=="))){
                            _evaluationResult = stringToUint(_queryResult) == stringToUint(_condition);
                        } else{
                            if(operatorHash == keccak256(bytes("!="))){
                                _evaluationResult = stringToUint(_queryResult) != stringToUint(_condition);
                            } else{
                                if(operatorHash == keccak256(bytes("special"))){
                                    _evaluationResult = true;
                                    _specialValue = _queryResult;
                                } else{

                                } 
                            } 
                        } 
                    } 
                } 
            } 
        } 

        return _evaluationResult;
    }

    /**
    * @notice Function to test if the badge produced using a BadgeDefinition can be mint.
    * @dev Check if the conditions to mint the badge are met.
    * @param _owner The Ethereum address of the user.
    * @param _badgeDefinitionId The ID of BadgeDefinition.
    * @return _evaluationResult The result of the test.
    */
    function doesOwnBadgeFromGivenDefinition(address _owner, uint _badgeDefinitionId) public view returns (bool _evaluationResult) {
        _evaluationResult = true;

        // Check for a BadgeToken potentially owned by this user associated to the BadgeDefinition
        if(_ownedBadges[_owner][_badgeDefinitionId] == 0){
            _evaluationResult = false;
        } 

        return _evaluationResult;
    }

    /**
    * @notice Function to transfer a token (if applicable).
    * @dev Transfers `tokenId` from `from` to `to`.
    * @param from The Ethereum address of the user that own the token.
    * @param to The Ethereum address of the user that could receive the token.
    * @param tokenId The ID of the BadgeToken.
    */
    function _transfer(address from, address to, uint256 tokenId) internal override {
        uint tokenIdex = tokenId - 1;

        // Check if the token can be transfered
        require(badgeDefinitionFactory.isBadgeTransferable(_badgeTokens[tokenIdex].badgeDefinitionId), string(abi.encodePacked(badgeTokenSymbol, ": this token is bind to its original owner", _badgeTokens[tokenIdex].originalOwner)));

        // Transfer the token (if applicable)
        super._transfer(from, to, tokenId);
    }

    /**
    * @notice Function to get the URI associated to a token.
    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
    * @param tokenId The ID of the BadgeToken.
    * @return The result URI associated to the token.
    */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        uint tokenIdex = tokenId - 1;
        
        string memory URI = badgeDefinitionFactory.tokenURI(_badgeTokens[tokenIdex].badgeDefinitionId);
        return bytes(URI).length > 0
            ? string(URI)
            : '';
    }

    function stringToUint(string memory s) private pure returns (uint result) {
        bytes memory b = bytes(s);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }
}