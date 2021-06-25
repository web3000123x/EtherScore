// contracts/BadgeFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

abstract contract BadgeFactory is ERC721Enumerable {

    // Badge attribution condition structure
    struct BadgeAttributionCondition {
        uint badgeDefinitionId;
        string description;
        string indexer;     // service indexing the data (possible values: "thegraph")
        string protocol;    // subgraph on the indexer to use (possible values: "uniswap", "compound")
        string query;       // the query to run
        string operator;    // operator allowing to compare the query return
        string condition;   // value to compare with the query result
    }

    uint8 constant maxNumberOfAttributionConditions = 5;

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwnerOf(uint _badgeDefinitionId) {
        require(_exists(_badgeDefinitionId), "ERC721: attempt to modify nonexistent token");
        require(_isApprovedOrOwner(_msgSender(), _badgeDefinitionId), "ERC721: modifier caller is not owner nor approved");
        _;
    }

    /**
    * @dev Throws if called for a non-existing badge.
    */
    modifier existingBadge(uint _badgeDefinitionId) {
        require(_exists(_badgeDefinitionId), "ERC721: attempt to modify nonexistent token");
        _;
    }
}