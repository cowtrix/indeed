pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DeedRegistry.sol";

contract TestDeedRegistry 
{
	string constant ownerName = "Yuri Gagarin";
	string constant fileName = "HelloWorld.txt";
	string constant fileDescription = "A hello world document.";

	uint blockNumber;
	
	function fakeHash() private pure returns (uint256)
	{
		return 0x11111111111111111111;
	}

	function testAdd() public 
	{
		DeedRegistry registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		blockNumber = registry.createDeed(ownerName, fileName,	fileDescription, fakeHash());
		assert(blockNumber > 0);		
	}

	// Unfortunately there doesn't seem to be a great way to test for reverts right now
	/*function testAddDuplicate() public 
	{
		DeedRegistry registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		uint zeroBlockNumber = registry.createDeed(ownerName, fileName,	fileDescription, fakeHash());
		assert(zeroBlockNumber == 0);		
	}*/
	
	function testCheckDeedExists() public
	{
		DeedRegistry registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		uint proveBlockNumber = registry.proveDeed(this, ownerName, fileName, fileDescription, fakeHash());
		assert(proveBlockNumber > 0 && proveBlockNumber == blockNumber);
	}
}
