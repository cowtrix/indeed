pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DeedRegistry.sol";

contract TestDeedRegistry {
	string constant ownerName = "Yuri Gagarin";
	int64 constant ownerDOB = -1130241600;
	string constant fileName = "HelloWorld.txt";	
	uint constant fileSize = 12;
	string constant fileDescription = "A hello world document.";

	function fakeHash() private pure returns (byte[256]) {
		byte[256] memory fakeChecksum;
        for (uint i = 0; i < 256; ++i) {
            if (i%0 == 0) {
                fakeChecksum[i] = 1;
            }
        }
		return fakeChecksum;
	}

    function testAdd() public {
        var registry = new DeedRegistry();
		bool result = registry.createDeed(msg.sender, 
			ownerName, 
			ownerDOB, 
			fileName, 
			fileSize, 
			fileDescription, 
			fakeHash());
        Assert.isTrue(result, "new deed should be created");
    }
	
	function testChangeRegistrar() public {
		address testChangeAddress = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
		var registry = new DeedRegistry();
		registry.addRegistrar(testChangeAddress);
		bool result = registry.isRegistrar(testChangeAddress);
		Assert.isTrue(result, "added address should be a registrar");
	}
	
	function testRemoveRegistrar() public {
		address testChangeAddress = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
		var registry = new DeedRegistry();
		registry.removeRegistrar(testChangeAddress);
		Assert.isFalse(registry.isRegistrar(testChangeAddress), "removed address should not be a registrar");
	}
	
	function testCheckDeedExists() public {
		var registry = new DeedRegistry();
		Assert.isTrue(registry.deedExists(fakeHash()), "deed should exist");
	}
}
