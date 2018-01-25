var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var DeedRegistry = artifacts.require("./DeedRegistry.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(DeedRegistry);
};
