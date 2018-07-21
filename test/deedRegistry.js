var DeedRegistry = artifacts.require("./DeedRegistry.sol");

contract('DeedRegistry', function(accounts) 
{
  var ownerName = "Yuri Gagarin";
	var fileName = "HelloWorld.txt";
	var fileDescription = "A hello world document.";

	var blockNumber;

	function fakeHash ()
	{
		return web3.toBigNumber('0xfc9e0eefe9f3a5101b7c025b217c03c95dbf9bb4f2d1d46db238e305af104103');
	}

  it("...should add a new deed.", function() {
    return DeedRegistry.deployed().then(function(instance) {
      deedRegInstance = instance;
			blockNumber = deedRegInstance.createDeed(ownerName, fileName, fileDescription, fakeHash(), {from: accounts[0]});			
		}).then()
		{
			assert(blockNumber > web3.toBigNumber(0), "Returned block number should be > 0");
		}
	});
	
	it("...should prove that the new deed exists.", function() {
    return DeedRegistry.deployed().then(function(instance) {
      deedRegInstance = instance;
			var checkBlockNumber = deedRegInstance.proveDeed(accounts[0], ownerName, fileName, fileDescription, fakeHash(), {from: accounts[0]});
		}).then()
		{
			assert(blockNumber == checkBlockNumber, "Block numbers should be equal. Currently " + blockNumber + " | " + checkBlockNumber);
		}
  });

});
