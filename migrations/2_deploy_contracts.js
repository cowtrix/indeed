var DeedRegistry = artifacts.require("./DeedRegistry.sol");

module.exports = function(deployer) {
  deployer.deploy(DeedRegistry);
};
