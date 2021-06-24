// contracts/BadgeDefinition.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

/// @title This contract allows to create badge definitions
/// @author Geoffrey Garcia
/// @notice Used to store the badge definitions within the blockchain
contract BadgeDefinition2 is Ownable {

    mapping(string => uint8) hashes;

    // Badge attribution condition structure
    struct BadgeAttributionCondition {
        //uint id;
        string description;
        string indexer;     // service indexing the data (possible values: "thegraph")
        string protocol;    // subgraph on the indexer to use (possible values: "uniswap", "compound")
        string query;       // the query to run
        string operator;    // operator allowing to compare the query return
        string condition;   // value to compare with the query result
    }

    // Badge definition structure
    struct BadgeDefinitionCollection {
        //uint id;
        string name;
        string description;
        //address owner;
        string[] tags;
        string image_url;
        BadgeAttributionCondition[] conditions;
    }

    // Storage of the badge definitions
    BadgeDefinitionCollection[] public badgeDefinitions;

    // function _createBadgeDefinition(string _name, string _description, string[] _tags, string _image_url, BadgeAttributionCondition[] _conditions) internal {
    //     uint badgeDefinitionId = badgeDefinitions.push(BadgeDefinitionCollection(_name, _description, _tags, _image_url, _conditions));
    //     zombieToOwner[id] = msg.sender;
    //     ownerZombieCount[msg.sender]++;
    //     NewZombie(id, _name, _dna);
    // }

    // function _createBadgeAttributionCondition(string _description, string _indexer, string _protocol, string _query, string _operator, string _condition) internal {
    //     uint id = tokens.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    //     zombieToOwner[id] = msg.sender;
    //     ownerZombieCount[msg.sender]++;
    //     NewZombie(id, _name, _dna);
    // }
}