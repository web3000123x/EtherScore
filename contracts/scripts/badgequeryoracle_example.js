// scripts/index2.js
module.exports = async function main(callback) {
  try {
    // Retrieve accounts from the local node
    const accounts = await web3.eth.getAccounts();
    console.log(accounts)

    // Set up a Truffle contract, representing our deployed BadgeTokenFactory instance
    const BadgeQueryOracle = artifacts.require("BadgeQueryOracle");
    const badgeQueryOracle = await BadgeQueryOracle.deployed();

    //function owner() public view virtual returns (address)
    value = await badgeQueryOracle.owner();
    console.log("owner: The owner of the BadgeQueryOracle is the account", value.toString());

    value = await badgeQueryOracle.runQuery();
    console.log("lol?", value.toString());

    callback(0);
  } catch (error) {
    console.error(error);
    callback(1);
  }
}