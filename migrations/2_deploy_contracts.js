var DeedRegistry = artifacts.require("DeedRegistry");

module.exports = function(deployer) {
  deployer.deploy(DeedRegistry);
};
