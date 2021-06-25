// scripts/index2.js
module.exports = async function main(callback) {
    try {
      // Set up a Truffle contract, representing our deployed BadgeDefinitionFactory instance
      const BadgeDefinition = artifacts.require("BadgeDefinitionFactory");
      const badgeDefinition = await BadgeDefinition.deployed();

      // Call the createBadgeDefinition() function of the deployed BadgeDefinitionFactory contract
      value = await badgeDefinition.createBadgeDefinition();
      console.log("The new BadgeDefinitionId is", value.toString());

      // ERC721 functions
      //function balanceOf(address owner) public view returns (uint256)

      //function ownerOf(uint256 tokenId) public view returns (address)

      //function name() public view returns (string memory) 

      //function symbol() public view returns (string memory)

      //function tokenURI(uint256 tokenId) public view returns (string memory)

      //function approve(address to, uint256 tokenId) publi

      //function getApproved(uint256 tokenId) public view returns (address)

      //function setApprovalForAll(address operator, bool approved) public

      //function isApprovedForAll(address owner, address operator) public view virtual override returns (bool)

      //function transferFrom(address from, address to, uint256 tokenId) public virtual override

      //function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override

      //function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override

      // ERC721Enumerable functions
      //function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool)

      //function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256)

      //function totalSupply() public view virtual override returns (uint256)

      //function tokenByIndex(uint256 index) public view virtual override returns (uint256)

      callback(0);
    } catch (error) {
      console.error(error);
      callback(1);
    }
  }