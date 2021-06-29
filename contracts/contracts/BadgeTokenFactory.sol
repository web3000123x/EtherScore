// contracts/BadgeTokenFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BadgeDefinitionFactory.sol";

/**
 * @title BadgeTokenFactory
 * @author Geoffrey Garcia
 * @notice Contract to use to mint and to transfer (if applicable based on associated BadgeDefinition) BadgeToken that are ERC721 tokens.
 * @dev The BadgeTokenFactory contract provides basic structures, functions & modifiers that allows to manage BadgeToken as ERC721 token.
 */
contract BadgeTokenFactory is BadgeFactory {

    /**
    * @notice Event emitted after a BadgeToken minting.
    * @dev Event emitted after a BadgeToken minting.
    * @param _badgeTokenId The ID of the BadgeToken.
    * @param _originalOwner The Ethereum address of the user that has minted the token.
    */
    event NewBadgeToken(uint _badgeTokenId, address _originalOwner);

    /**
    * @notice Event emitted when the contract need the result of a query (requesting it to an oracle through this event).
    * @dev Event emitted each time a condition has to be evaluated.
    * @param _indexer The service indexing the data (possible values: "thegraph").
    * @param _protocol The set/subgraph on the indexer to use (possible values: "uniswap", "compound").
    * @param _query The query to run.
    */
    event NeedQueryRun(string _indexer, string _protocol, string _query);

    // Badge token structure
    struct BadgeToken {
        uint badgeDefinitionId; // the ID of BadgeDefinition associated to this BadgeToken
        address originalOwner;  // the Ethereum address of the user that has minted the token
    }

    // Storage of the badge definitionsg
    BadgeToken[] private _badgeTokens;                              // BadgeToken storage
    mapping(address => mapping(uint => uint)) private _ownedBadges; // List of BadgeToken IDs per owner per BadgeDefinition
    string badgeTokenSymbol = "BTO";                                // Symbol of the ERC721 tokens of the BadgeToken

    // Reference to the BadgeDefinitionFactory contract allowing to manage BadgeDefinition
    BadgeDefinitionFactory badgeDefinitionFactory;

    /**
    * @dev See {ERC721-constructor}.
    * @param _badgeDefinitionFactoryAddress The Ethereum address of the BadgeDefinitionFactory contract allowing to manage BadgeDefinition.
    */
    constructor(address _badgeDefinitionFactoryAddress) BadgeFactory("BadgeToken", badgeTokenSymbol) {
        // Linking this contract with the already deployed one BadgeDefinitionFactory
        badgeDefinitionFactory = BadgeDefinitionFactory(_badgeDefinitionFactoryAddress);
    }

    /**
    * @notice Function to mint a BadgeToken as ERC721 tokens.
    * @dev Creates & store a BadgeToken.
    * @param _badgeDefinitionId The ID of BadgeDefinition associated to this BadgeToken.
    * @return _badgeTokenId The ID of the new BadgeToken.
    */
    function mintBadgeToken(uint _badgeDefinitionId) public returns (uint _badgeTokenId) {
        // Asserting the user has not a token of the same kind already & fullfill the conditions to get one
        require(_ownedBadges[_msgSender()][_badgeDefinitionId] == 0, string(abi.encodePacked(badgeTokenSymbol, ": badge already owned")));
        //TODO: check orignalOwner instead?
        require(_assessAttributionCondition(_badgeDefinitionId), string(abi.encodePacked(badgeTokenSymbol, ": attempt to mint a token without fullfilling the attribution conditions to get it")));
        
        // Storing the BadgeToken
        _badgeTokens.push(BadgeToken({ badgeDefinitionId: _badgeDefinitionId, originalOwner: _msgSender()}));
        
        // Getting the ID of the new BadgeToken
        // uint badgeTokenId = _badgeTokens.length - 1;
        uint badgeTokenId = _badgeTokens.length;

        // Add the badge to the ones owned by the user
        _ownedBadges[_msgSender()][_badgeDefinitionId] = badgeTokenId;

        // Minting the BadgeToken
        _safeMint(_msgSender(), badgeTokenId);

        // Emit the appropriate event
        emit NewBadgeToken(badgeTokenId, _msgSender());

        return badgeTokenId;
    }

    /**
    * @notice Function to test if the badge produced using a BadgeDefinition can be mint.
    * @dev Check if the conditions to mint the badge are met.
    * @param _badgeDefinitionId The ID of BadgeDefinition associated to this BadgeToken.
    * @return _evaluationResult The result of the test.
    */
    function _assessAttributionCondition(uint _badgeDefinitionId) private view returns (bool _evaluationResult) {
        _evaluationResult = true;

        // Get the BadgeAttributionCondition list associated to this BadgeDefinition
        BadgeAttributionCondition[maxNumberOfAttributionConditions] memory badgeAttributionCondition;
        uint numberOfConditions = 0;
        (numberOfConditions, badgeAttributionCondition) = badgeDefinitionFactory.getBadgeDefinitionAttributionCondition(_badgeDefinitionId);
        
        // Check for every condition in the list
        for(uint i=0; (i < numberOfConditions) && (_evaluationResult == true); i++){

            // Evalute if the condition is met
            string memory queryResult = _runQuery(badgeAttributionCondition[i].indexer, badgeAttributionCondition[i].protocol, badgeAttributionCondition[i].query);
            _evaluationResult = _evaluateCondition(queryResult, badgeAttributionCondition[i].operator, badgeAttributionCondition[i].condition);
        } 

        return _evaluationResult;
    }

    /**
    * @notice Function to run a query.
    * @dev Run a query in order to be able to check if a condition to mint a badge is met.
    * @param _indexer The service indexing the data (possible values: "thegraph").
    * @param _protocol The set/subgraph on the indexer to use (possible values: "uniswap", "compound").
    * @param _query The query to run.
    * @return _queryResult The result of the query.
    */
    function _runQuery(string memory _indexer, string memory _protocol, string memory _query) private view returns (string memory _queryResult) {
        _queryResult = "";

        //TODO: run the query

        return _queryResult;
    }

    /**
    * @notice Function to evaluate a condition.
    * @dev Check if a condition to mint a badge is met.
    * @param _queryResult The result of the query.
    * @param _operator The operator allowing to compare the query return.
    * @param _condition The value to compare with the query result.
    * @return _evaluationResult The result of the test.
    */
    function _evaluateCondition(string memory _queryResult, string memory _operator, string memory _condition) private view returns (bool _evaluationResult) {
        _evaluationResult = true;

        //TODO: run the query

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
}