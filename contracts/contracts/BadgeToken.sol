// contracts/BadgeToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "./BadgeDefinitionFactory.sol";

/// @title This contract allows to create badge tokens (based on their own definition)
/// @author Geoffrey Garcia
/// @notice Used to store the badge tokens within the blockchain
contract BadgeToken is Ownable {

    using Counters for Counters.Counter;

    Counters.Counter private _badgeTokenIds;
    mapping(string => uint8) hashes;

    // Badge token structure
    struct BadgeTokenCollection {
      string name;
    }

    // Storage of the badge tokens
    BadgeTokenCollection[] public badgeTokens;
}
