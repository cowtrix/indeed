pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DeedRegistry.sol";

contract TestDeedRegistry 
{
	string constant ownerName = "Yuri Gagarin";
	string constant fileName = "HelloWorld.txt";
	string constant fileDescription = "A hello world document.";
	
	function fakeHash() private pure returns (byte[256])
	{
		byte[256] memory fakeChecksum;
        for(uint i = 0; i < 256; ++i)
        {
            if(i%2 == 0)
            {
                fakeChecksum[i] = 255;
            }
        }
		return fakeChecksum;
	}

	function testAdd() public 
	{
		DeedRegistry registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		assert(registry.createDeed(ownerName, fileName,	fileDescription, fakeHash()) > 0);		
	}
	
	function testCheckDeedExists() public view
	{
		DeedRegistry registry = DeedRegistry(DeployedAddresses.DeedRegistry());
		assert(registry.proveDeed(this, ownerName, fileName, fileDescription, fakeHash()) > 0);
	}
}
