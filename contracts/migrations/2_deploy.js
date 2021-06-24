// migrations/2_deploy.js
// const BadgeDefinition = artifacts.require("BadgeDefinition");
const BadgeDefinitionFactory = artifacts.require("BadgeDefinitionFactory");

module.exports = async function (deployer) {
  // await deployer.deploy(BadgeDefinition);
  await deployer.deploy(BadgeDefinitionFactory);
};