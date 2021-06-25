// scripts/index.js
module.exports = async function main(callback) {
    try {
      // Retrieve accounts from the local node
      const accounts = await web3.eth.getAccounts();
      console.log(accounts)
      callback(0);
    } catch (error) {
      console.error(error);
      callback(1);
    }
  }