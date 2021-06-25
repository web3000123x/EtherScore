// contracts/BadgeTokenFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BadgeDefinitionFactory.sol";

contract BadgeTokenFactory is BadgeFactory {

    event NewBadgeToken(uint badgeDefinitionId, string name, string description, string[] _tags, string _image_uri);

    // Badge token structure
    struct BadgeToken {
        uint badgeDefinitionId;
        address originalOwner;
    }

    // Storage of the badge definitionsg
    BadgeToken[] private _badgeTokens;
    mapping(uint => uint[]) private _conditionList;
    string badgeTokenSymbol = "BTO";

    BadgeDefinitionFactory badgeDefinitionFactory;

    constructor(address badgeDefinitionFactoryAddress) ERC721("BadgeToken", badgeTokenSymbol) {
        badgeDefinitionFactory = BadgeDefinitionFactory(badgeDefinitionFactoryAddress);
    }

    function createBadgeDefinition(uint _badgeDefinitionId) public returns (uint _badgeTokenId) {
        require(_assessAttributionCondition(_badgeDefinitionId), string(abi.encodePacked(badgeTokenSymbol, ": attempt to mint a token without fullfilling the attribution conditions to get it")));
        
        _badgeTokens.push(BadgeToken({ badgeDefinitionId: _badgeDefinitionId, originalOwner: _msgSender()}));
        uint badgeTokenId = _badgeTokens.length - 1;

        _safeMint(_msgSender(), badgeTokenId);

        return badgeTokenId;
    }

    function _assessAttributionCondition(uint _badgeDefinitionId) private view returns (bool) {
        bool res = true;

        //TODO: check for the list conditions
        BadgeAttributionCondition[maxNumberOfAttributionConditions] memory badgeAttributionCondition;
        uint numberOfConditions = 0;
        (numberOfConditions, badgeAttributionCondition) = badgeDefinitionFactory.getBadgeDefinitionAttributionCondition(_badgeDefinitionId);
        for(uint i=0; (i < numberOfConditions) && (res == true); i++){

            string memory queryResult = _runQuery(badgeAttributionCondition[i].indexer, badgeAttributionCondition[i].protocol, badgeAttributionCondition[i].query);
            res = _evaluateCondition(queryResult, badgeAttributionCondition[i].operator, badgeAttributionCondition[i].condition);
        } 

        return res;
    }


    function _runQuery(string memory _indexer, string memory _protocol, string memory _query) private view returns (string memory _queryResult) {
        _queryResult = "";

        //TODO: run the query

        return _queryResult;
    }

    function _evaluateCondition(string memory _indexer, string memory _operator, string memory _condition) private view returns (bool _evaluationResult) {
        _evaluationResult = true;

        //TODO: run the query

        return _evaluationResult;
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(address from, address to, uint256 tokenId) internal override {
        //TODO: check if the token can be transferred
        require(badgeDefinitionFactory.isBadgeTransferable(tokenId), string(abi.encodePacked(badgeTokenSymbol, ": this token is bind to its original owner", _badgeTokens[tokenId].originalOwner)));

        super._transfer(from, to, tokenId);
    }

    // /**
    //  * @dev See {IERC721Metadata-tokenURI}.
    //  */
    // function tokenURI(uint256 tokenId) public view override returns (string memory) {
    //     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

    //     return _badgeDefinitions[tokenId].image_uri;
    // }

    // /**
    //  * @dev See {IERC721-setApprovalForAll}.
    //  */
    // function setApprovalForAll(address operator, bool approved) public {
    //     require(operator != _msgSender(), "ERC721: approve to caller");

    //     _operatorApprovals[_msgSender()][operator] = approved;
    //     emit ApprovalForAll(_msgSender(), operator, approved);
    // }

    // /**
    //  * @dev See {IERC721-isApprovedForAll}.
    //  */
    // function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
    //     return _operatorApprovals[owner][operator];
    // }

    // /**
    //  * @dev See {IERC721-safeTransferFrom}.
    //  */
    // function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
    //     safeTransferFrom(from, to, tokenId, "");
    // }

    // /**
    //  * @dev See {IERC721-safeTransferFrom}.
    //  */
    // function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
    //     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
    //     _safeTransfer(from, to, tokenId, _data);
    // }

    // /**
    //  * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
    //  * are aware of the ERC721 protocol to prevent tokens from being forever locked.
    //  *
    //  * `_data` is additional data, it has no specified format and it is sent in call to `to`.
    //  *
    //  * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
    //  * implement alternative mechanisms to perform token transfer, such as signature-based.
    //  *
    //  * Requirements:
    //  *
    //  * - `from` cannot be the zero address.
    //  * - `to` cannot be the zero address.
    //  * - `tokenId` token must exist and be owned by `from`.
    //  * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    //  *
    //  * Emits a {Transfer} event.
    //  */
    // function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
    //     _transfer(from, to, tokenId);
    //     require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    // }

    // /**
    //  * @dev Returns whether `tokenId` exists.
    //  *
    //  * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
    //  *
    //  * Tokens start existing when they are minted (`_mint`),
    //  * and stop existing when they are burned (`_burn`).
    //  */
    // function _exists(uint256 tokenId) internal view virtual returns (bool) {
    //     return _owners[tokenId] != address(0);
    // }

    // /**
    //  * @dev Returns whether `spender` is allowed to manage `tokenId`.
    //  *
    //  * Requirements:
    //  *
    //  * - `tokenId` must exist.
    //  */
    // function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
    //     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
    //     address owner = ERC721.ownerOf(tokenId);
    //     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    // }

    // /**
    //  * @dev Destroys `tokenId`.
    //  * The approval is cleared when the token is burned.
    //  *
    //  * Requirements:
    //  *
    //  * - `tokenId` must exist.
    //  *
    //  * Emits a {Transfer} event.
    //  */
    // function _burn(uint256 tokenId) internal virtual {
    //     address owner = ERC721.ownerOf(tokenId);

    //     _beforeTokenTransfer(owner, address(0), tokenId);

    //     // Clear approvals
    //     _approve(address(0), tokenId);

    //     _balances[owner] -= 1;
    //     delete _owners[tokenId];

    //     emit Transfer(owner, address(0), tokenId);
    // }

    // /**
    //  * @dev Hook that is called before any token transfer. This includes minting
    //  * and burning.
    //  *
    //  * Calling conditions:
    //  *
    //  * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
    //  * transferred to `to`.
    //  * - When `from` is zero, `tokenId` will be minted for `to`.
    //  * - When `to` is zero, ``from``'s `tokenId` will be burned.
    //  * - `from` cannot be the zero address.
    //  * - `to` cannot be the zero address.
    //  *
    //  * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
    //  */
    // function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
}