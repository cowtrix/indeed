var DeedRegistry = artifacts.require("./DeedRegistry.sol");

contract('DeedRegistry', function(accounts) 
{
	var ownerName = "Yuri Gagarin";
	var fileName = "HelloWorld.txt";
	var fileDescription = "A hello world document.";

	var blockNumber1, blockNumber2;

	function fakeHash ()
	{
		return web3.toBigNumber('0xfc9e0eefe9f3a5101b7c025b217c03c95dbf9bb4f2d1d46db238e305af104103');
	}

	it("...should add a new deed.", function() 
	{
		return DeedRegistry.deployed().then(
			function(instance) 
			{
				deedRegInstance = instance;
				return deedRegInstance.createDeed(ownerName, fileName, fileDescription, fakeHash(), {from: accounts[0]});			
			}).then(function(number)
			{
				blockNumber1 = new web3.BigNumber(number);
				assert(blockNumber1 > web3.toBigNumber(0), "Returned block number should be > 0. It is currently " + blockNumber1);
				console.log("blockNumber1:" + typeof(blockNumber1));
			})
	});

	it("...should add the new deed again.", function() 
	{
		return DeedRegistry.deployed().then(
			function(instance) 
			{
				deedRegInstance = instance;
				return deedRegInstance.createDeed(ownerName, fileName, fileDescription, fakeHash(), {from: accounts[0]});			
			}).then(function(number)
			{
				blockNumber2 = number;
				assert(blockNumber2 > web3.toBigNumber(0), "Returned block number should be > 0. It is currently " + blockNumber2);
				console.log("blockNumber2:" + typeof(blockNumber2));
			})
	});

	it("...should prove that the first deed exists (no block number target)", function() {
		return DeedRegistry.deployed().then(function(instance) 
		{
			deedRegInstance = instance;
			return deedRegInstance.proveDeed(accounts[0], ownerName, fileName, fileDescription, fakeHash(), web3.toBigNumber(0), {from: accounts[0]});
	}).then(
		function(checkBlockNumber1)
		{
			checkBlockNumber1 = web3.toBigNumber(checkBlockNumber1);
			assert(blockNumber1 == checkBlockNumber1, "Block numbers should be equal. Currently " + blockNumber1 + " | " + checkBlockNumber1);
		})
	});

	/*it("...should prove that the first deed exists (with block number target)", function() {
		return DeedRegistry.deployed().then(function(instance) {
			deedRegInstance = instance;
			return deedRegInstance.proveDeed(accounts[0], ownerName, fileName, fileDescription, fakeHash(), web3.toBigNumber(blockNumber2), {from: accounts[0]});
		}).then(function(checkBlockNumber2)
		{
			checkBlockNumber2 = web3.toBigNumber(checkBlockNumber2);
			assert(blockNumber2 == checkBlockNumber2, "Block numbers should be equal. Currently " + blockNumber2 + " | " + checkBlockNumber2);
		})
	});*/

});
