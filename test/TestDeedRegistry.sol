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
	uint secondBlockNumber;
	
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

	function testAddDuplicate() public 
	{
		DeedRegistry registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		secondBlockNumber = registry.createDeed(ownerName, fileName, fileDescription, fakeHash());
		assert(secondBlockNumber > blockNumber);
	}
	
	function proveFirstDeedExists() public
	{
		DeedRegistry registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		uint proveBlockNumber = registry.proveDeed(this, ownerName, fileName, fileDescription, fakeHash(), 0);
		assert(proveBlockNumber > 0 && proveBlockNumber == blockNumber);
	}

	function proveSecondDeedExists() public
	{
		DeedRegistry registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		uint proveBlockNumber = registry.proveDeed(this, ownerName, fileName, fileDescription, fakeHash(), secondBlockNumber);
		assert(proveBlockNumber > 0 && proveBlockNumber == secondBlockNumber);
	}
}
