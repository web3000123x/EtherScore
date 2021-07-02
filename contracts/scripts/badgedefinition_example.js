// scripts/badgedefinition_example.js
module.exports = async function main(callback) {
    try {
      // Retrieve accounts from the local node
      const accounts = await web3.eth.getAccounts();
      console.log(accounts)
      let creator_address = accounts[0];
      let receiver_address = accounts[1];
      let token_number = Math.ceil(Math.random() * 10000);
      let token_number2 = Math.ceil(Math.random() * 10000);
      console.log("The 1st BadgeDefinition will be called definition#" + token_number + " (will be claimed)");
      console.log("The 2nd BadgeDefinition will be called definition#" + token_number2 + " (will be droped)");

      // Set up a Truffle contract, representing our deployed BadgeDefinitionFactory instance
      const BadgeDefinitionFactory = artifacts.require("BadgeDefinitionFactory");
      const badgeDefinitionFactory = await BadgeDefinitionFactory.deployed();

      // Call the createBadgeDefinition function of the deployed BadgeDefinitionFactory contract
      // (badge 1 - BadgeToken NOT transferrable)
      await badgeDefinitionFactory.createBadgeDefinition("definition#" + token_number, "this is the definition#" + token_number, ["a tag", "another tag"], "i.redd.it/rq36kl1xjxr01.png", false);

      await badgeDefinitionFactory.getPastEvents( 'Transfer', { fromBlock: 'latest', toBlock: 'latest' } )
      .then(function(events){
          badgeId = events[0]["returnValues"]["tokenId"];
      });
      console.log("createBadgeDefinition: The new BadgeDefinitionId for badge definition#" + token_number, "is", badgeId.toString());

      // (badge 2 - BadgeToken transferrable)
      await badgeDefinitionFactory.createBadgeDefinition("definition#" + token_number2, "this is the definition#" + token_number2, ["a tag", "another tag"], "i.redd.it/rq36kl1xjxr01.png", true);
      
      await badgeDefinitionFactory.getPastEvents( 'Transfer', { fromBlock: 'latest', toBlock: 'latest' } )
      .then(function(events){
          badgeId2 = events[0]["returnValues"]["tokenId"];
      });
      console.log("createBadgeDefinition: The new BadgeDefinitionId for badge definition#" + token_number2, "is", badgeId2.toString());

      // Call the addBadgeAttributionCondition function of the deployed BadgeDefinitionFactory contract
      let query = "{ swaps(orderBy: timestamp, where: { to: " + creator_address + " }) { id transaction { id timestamp } pair { token0 { symbol } token1 { symbol } } to sender } }";
      let operator = ">=";
      let condition = "50";

      // (badge 1 - 2 conditions)
      await badgeDefinitionFactory.addBadgeAttributionCondition(badgeId, "condition1 of definition#" + token_number, "thegraph", "uniswap", query, operator, condition);
      await badgeDefinitionFactory.addBadgeAttributionCondition(badgeId, "condition2 of definition#" + token_number, "thegraph", "uniswap", query, operator, condition);

      // (badge 2 - 1 condition)
      await badgeDefinitionFactory.addBadgeAttributionCondition(badgeId2, "condition1 of definition#" + token_number2, "thegraph", "uniswap", query, operator, condition);

      // Call the publishBadgeDefinition function of the deployed BadgeDefinitionFactory contract
      // (badge 1)
      await badgeDefinitionFactory.publishBadgeDefinition(badgeId);

      // (badge 2)
      await badgeDefinitionFactory.publishBadgeDefinition(badgeId2);

      // Call the getBadgeDefinitionAttributionCondition function of the deployed BadgeDefinitionFactory contract
      // (badge 1)
      value = await badgeDefinitionFactory.getBadgeDefinitionAttributionCondition(badgeId);
      console.log("getBadgeDefinitionAttributionCondition: The BadgeDefinitionId", badgeId, "has got", value[0].toString(), "condition(s)");
      console.log(value[1]);

      // Call the isBadgeTransferable function of the deployed BadgeDefinitionFactory contract
      // (badge 1)
      value = await badgeDefinitionFactory.isBadgeTransferable(badgeId);
      console.log("isBadgeTransferable: Are the badges produced using the BadgeDefinitionId", badgeId, "transferrable?", value.toString());

      // (badge 2)
      value = await badgeDefinitionFactory.isBadgeTransferable(badgeId2);
      console.log("isBadgeTransferable: Are the badges produced using the BadgeDefinitionId", badgeId2, "transferrable?", value.toString());

      // ERC721 functions
      //function balanceOf(address owner) public view returns (uint256)
      // (creator_address)
      value = await badgeDefinitionFactory.balanceOf(creator_address);
      console.log("balanceOf: The account", creator_address, "has got", value.toString(), "badge(s)");

      // (receiver_address)
      value = await badgeDefinitionFactory.balanceOf(receiver_address);
      console.log("balanceOf: The account", receiver_address, "has got", value.toString(), "badge(s)");

      //function ownerOf(uint256 tokenId) public view returns (address)
      // (badge 1)
      value = await badgeDefinitionFactory.ownerOf(badgeId);
      console.log("ownerOf: The owner of the badge", badgeId.toString(), "is the account", value.toString());

      // (badge 2)
      value = await badgeDefinitionFactory.ownerOf(badgeId2);
      console.log("ownerOf: The owner of the badge", badgeId2.toString(), "is the account", value.toString());

      //function name() public view returns (string memory) 
      value = await badgeDefinitionFactory.name();
      console.log("name: The name of the contract is", value);

      //function symbol() public view returns (string memory)
      value = await badgeDefinitionFactory.symbol();
      console.log("symbol: The symbol of the badges of the contract is", value);

      //function tokenURI(uint256 tokenId) public view returns (string memory)
      value = await badgeDefinitionFactory.tokenURI(badgeId);
      console.log("tokenURI: The URI associated with the badge", badgeId.toString(), "is", value.toString());

      //function approve(address to, uint256 tokenId) public
      await badgeDefinitionFactory.approve(receiver_address, badgeId);
      console.log("approve: There is an attempt for the account", receiver_address, "to be approved to claim the badge", badgeId.toString());

      //function getApproved(uint256 tokenId) public view returns (address)
      value = await badgeDefinitionFactory.getApproved(badgeId);
      console.log("getApproved: The account", value.toString(), "has been approved to claim the badge", badgeId.toString());

      //function setApprovalForAll(address operator, bool approved) public

      //function isApprovedForAll(address owner, address operator) public view virtual override returns (bool)

      //function transferFrom(address from, address to, uint256 tokenId) public virtual override
      // (badge 1)
      await badgeDefinitionFactory.transferFrom(creator_address, receiver_address, badgeId, {from: receiver_address});
      console.log("transferFrom: The badge", badgeId.toString(), "has been claimed by the account", receiver_address);

      // (badge 2)
      await badgeDefinitionFactory.transferFrom(creator_address, receiver_address, badgeId2);
      console.log("transferFrom: The badge", badgeId2.toString(), "has been drop by the account", creator_address, "to the account", receiver_address);

      //CHECK
      //function balanceOf(address owner) public view returns (uint256)
      // (creator_address)
      total1 = await badgeDefinitionFactory.balanceOf(creator_address);
      console.log("balanceOf: The account", creator_address, "has got", total1.toString(), "badge(s)");

      // (receiver_address)
      total2 = await badgeDefinitionFactory.balanceOf(receiver_address);
      console.log("balanceOf: The account", receiver_address, "has got", total2.toString(), "badge(s)");

      //CHECK
      //function ownerOf(uint256 tokenId) public view returns (address)
      // (badge 1)
      value = await badgeDefinitionFactory.ownerOf(badgeId);
      console.log("ownerOf: The owner of the badge", badgeId.toString(), "is the account", value.toString());

      // (badge 2)
      value = await badgeDefinitionFactory.ownerOf(badgeId2);
      console.log("ownerOf: The owner of the badge", badgeId2.toString(), "is the account", value.toString());

      //function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override

      //function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override

      // ERC721Enumerable functions
      //function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool)
      //ERC721
      value = await badgeDefinitionFactory.supportsInterface('0x80ac58cd');
      console.log("supportsInterface: Does the contract support IERC721?", value.toString());

      //function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256)
      // (badge 1)
      for(i = 0; i < total1; i++){
        value = await badgeDefinitionFactory.tokenOfOwnerByIndex(creator_address, i);
        console.log("tokenOfOwnerByIndex: The badge own by", creator_address, "at the index", i.toString(), "is", value.toString())
      } 

      // (badge 2)
      for(i = 0; i < total2; i++){
        value = await badgeDefinitionFactory.tokenOfOwnerByIndex(receiver_address, i);
        console.log("tokenOfOwnerByIndex: The badge own by", receiver_address, "at the index", i.toString(), "is", value.toString())
      } 

      //function totalSupply() public view virtual override returns (uint256)
      amount = await badgeDefinitionFactory.totalSupply();
      console.log("totalSupply: The total amount of badges is", amount.toString());

      //function tokenByIndex(uint256 index) public view virtual override returns (uint256)
      for(i = 0; i < amount; i++){
        value = await badgeDefinitionFactory.tokenByIndex(i);
        console.log("tokenByIndex: The badge at the index", i.toString(), "is", value.toString());
      }

      callback(0);
    } catch (error) {
      console.error(error);
      callback(1);
    }
  }