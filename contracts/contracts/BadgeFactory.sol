// contracts/BadgeFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/**
 * @title BadgeFactory
 * @author Geoffrey Garcia
 * @notice Implementation of ERC721 standard using OpenZeppelin library
 * @dev The BadgeFactory abstract contract provides basic structures & modifiers that simplify the implementation of BadgeDefinitionFactory & BadgeTokenFactory.
 */
abstract contract BadgeFactory is ERC721Enumerable {

    // Badge attribution condition structure
    struct BadgeAttributionCondition {
        uint badgeDefinitionId; // the ID of BadgeDefinition associated to this condition
        string description;     // the descrition of the condition
        string indexer;         // the service indexing the data (possible values: "thegraph")
        string protocol;        // the set/subgraph on the indexer to use (possible values: "uniswap", "compound")
        string query;           // the query to run
        string operator;        // the operator allowing to compare the query return
        string condition;       // the value to compare with the query result
    }

    // Maximum number of conditions that can be associated to a single badge
    uint8 constant maxNumberOfAttributionConditions = 5;

    /**
    * @dev Throws if called by any account other than the owner.
    * @param _badgeId The ID of the Badge.
    */
    modifier onlyOwnerOf(uint _badgeId) {
        require(_exists(_badgeId), "ERC721: attempt to modify nonexistent token");
        require(_isApprovedOrOwner(_msgSender(), _badgeId), "ERC721: modifier caller is not owner nor approved");
        _;
    }

    /**
    * @dev Throws if called for a non-existing badge.
    * @param _badgeId The ID of the Badge.
    */
    modifier existingBadge(uint _badgeId) {
        require(_exists(_badgeId), "ERC721: attempt to modify nonexistent token");
        _;
    }
}