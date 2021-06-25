// contracts/BadgeDefinitionFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BadgeFactory.sol";

contract BadgeDefinitionFactory is BadgeFactory {

    event NewBadgeDefinition(uint badgeDefinitionId, string name, string description, string[] _tags, string _image_uri);
    
    // Badge definition structure
    struct BadgeDefinition {
        string name;
        string description;
        string[] tags;
        string image_uri;
        bool isTransferable;
        bool isPublished;
    }

    // Storage of the badge definitionsg
    BadgeDefinition[] private _badgeDefinitions;
    BadgeAttributionCondition[] private _badgeAttributionConditions;
    mapping(uint => uint[]) private _attributionConditionList;
    string badgeDefinitionSymbol = "BDE";

    constructor() ERC721("BadgeDefinition", badgeDefinitionSymbol) {
    }

    /**
    * @dev Throws if called on an already published token.
    */
    modifier onlyUnpublishedBadgeDefinition(uint _badgeDefinitionId) {
        require(!(_badgeDefinitions[_badgeDefinitionId].isPublished), string(abi.encodePacked(badgeDefinitionSymbol, ": attempt to modify an already published token (now read-only)")));
        _;
    }

    /**
    * @dev Throws if called on an unpublished token.
    */
    modifier onlyPublishedBadgeDefinition(uint _badgeDefinitionId) {
        require(_badgeDefinitions[_badgeDefinitionId].isPublished, string(abi.encodePacked(badgeDefinitionSymbol, ": attempt to use an unpublished token (it has to be published first)")));
        _;
    }

    function createBadgeDefinition(string memory _name, string memory _description, string[] memory _tags, string memory _image_uri, bool _isTransferable) public returns (uint _badgeDefinitionId) {
        _badgeDefinitions.push(BadgeDefinition({ name: _name, description: _description, tags: _tags, image_uri: _image_uri, isTransferable: _isTransferable, isPublished: false}));
        uint badgeDefinitionId = _badgeDefinitions.length - 1;

        _safeMint(_msgSender(), badgeDefinitionId);

        return badgeDefinitionId;
    }

    function addBadgeAttributionCondition(uint _badgeDefinitionId, string memory _description, string memory _indexer, string memory _protocol, string memory _query, string memory _operator, string memory _condition) public onlyOwnerOf(_badgeDefinitionId) onlyUnpublishedBadgeDefinition(_badgeDefinitionId) {
        require(_attributionConditionList[_badgeDefinitionId].length <= maxNumberOfAttributionConditions, string(abi.encodePacked(badgeDefinitionSymbol, ": maximum number of conditions for the token already reached")));
        _badgeAttributionConditions.push(BadgeAttributionCondition({ badgeDefinitionId:_badgeDefinitionId, description: _description, indexer: _indexer, protocol: _protocol, query: _query, operator: _operator, condition: _condition}));
        uint badgeAttributionConditionId = _badgeAttributionConditions.length - 1;

        //Updating the relationship with its parent
        _attributionConditionList[_badgeDefinitionId].push(badgeAttributionConditionId);
    }

    function publishBadgeDefinition(uint _badgeDefinitionId) public onlyOwnerOf(_badgeDefinitionId) onlyUnpublishedBadgeDefinition(_badgeDefinitionId) {
        _badgeDefinitions[_badgeDefinitionId].isPublished = true;

        emit NewBadgeDefinition(_badgeDefinitionId, _badgeDefinitions[_badgeDefinitionId].name, _badgeDefinitions[_badgeDefinitionId].description, _badgeDefinitions[_badgeDefinitionId].tags, _badgeDefinitions[_badgeDefinitionId].image_uri);
    } 

    function getBadgeDefinitionAttributionCondition(uint _badgeDefinitionId) public view existingBadge(_badgeDefinitionId) onlyPublishedBadgeDefinition(_badgeDefinitionId) returns (uint _numberOfAttributionCondition, BadgeAttributionCondition[maxNumberOfAttributionConditions] memory _badgeDefinitionAttributionConditions) {
        _numberOfAttributionCondition = _attributionConditionList[_badgeDefinitionId].length;
        for(uint i=0; i < _numberOfAttributionCondition; i++){
            _badgeDefinitionAttributionConditions[i] = _badgeAttributionConditions[_attributionConditionList[_badgeDefinitionId][i]];
        }

        return (_numberOfAttributionCondition, _badgeDefinitionAttributionConditions);
    }

    function isBadgeTransferable(uint _badgeDefinitionId) public view onlyPublishedBadgeDefinition(_badgeDefinitionId) returns (bool _isTransferable) {
        return _badgeDefinitions[_badgeDefinitionId].isTransferable;
    } 

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        return _badgeDefinitions[tokenId].image_uri;
    }

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