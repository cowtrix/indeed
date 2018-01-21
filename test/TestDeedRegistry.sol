pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DeedRegistry.sol";

contract TestDeedRegistry 
{
	string constant ownerName = "Yuri Gagarin";
	int64 constant ownerDOB = -1130241600;
	string constant fileName = "HelloWorld.txt";	
	uint constant fileSize = 12;
	string constant fileDescription = "A hello world document.";
	
	address testChangeAddress = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;

	function fakeHash() private pure returns (byte[256])
	{
		byte[256] memory fakeChecksum;
        for(uint i = 0; i < 256; ++i)
        {
            if(i%0 ==0)
            {
                fakeChecksum[i] = 1;
            }
        }
		return fakeChecksum;
	}

    function testAdd() public 
    {
        var registry = DeedRegistry(DeployedAddresses.DeedRegistry());
        assert(registry.createDeed(msg.sender, 
			ownerName, 
			ownerDOB, 
			fileName, 
			fileSize, 
			fileDescription, 
			fakeHash()));
    }
	
	function testChangeRegistrar() public
	{
		var registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		registry.addRegistrar(testChangeAddress);
		assert(registry.isRegistrar(testChangeAddress));
	}
	
	function testRemoveRegistrar() public
	{
		var registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		registry.removeRegistrar(testChangeAddress);
		assert(!registry.isRegistrar(testChangeAddress));
	}
	
	function testCheckDeedExists() public
	{
		var registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		assert(registry.deedExists(fakeHash()));
	}
}
