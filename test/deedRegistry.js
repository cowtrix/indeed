var DeedRegistry = artifacts.require("./DeedRegistry.sol");

contract('DeedRegistry', function(accounts) 
{
  it("...should add a new registrar.", function() {
    return DeedRegistry.deployed().then(function(instance) 
	{
		instance.addRegistrar(accounts[0], {from: accounts[0]});
		return instance.isRegistrar(accounts[0]);
    });
  });

});
