var DeedRegistry = artifacts.require("./DeedRegistry.sol");

contract('DeedRegistry', function(accounts) 
{
  var ownerName = "Yuri Gagarin";
	var fileName = "HelloWorld.txt";
	var fileDescription = "A hello world document.";

	function fakeHash ()
	{
		var hash = new Uint8Array(256);
		for(var i = 0; i < 256; ++i)
		{
			hash[i] = 127;
		}
		return hash;
	}

  it("...should add a new deed.", function() {
    return DeedRegistry.deployed().then(function(instance) {
      deedRegInstance = instance;

      assert(deedRegInstance.createDeed(
        ownerName,
			  fileName,
			  fileDescription, 
				fakeHash(), 
				{from: accounts[0]}) > 0);
    })
	});
	
	it("...should check that the new deed exists.", function() {
    return DeedRegistry.deployed().then(function(instance) {
      deedRegInstance = instance;

      assert(deedRegInstance.proveDeed(
				accounts[0],
        ownerName,
			  fileName,
			  fileDescription, 
				fakeHash(), 
				{from: accounts[0]}) > 0);
    })
  });

});
