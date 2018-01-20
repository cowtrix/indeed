pragma solidity ^0.4.16;

// A deployment contract for the Indeed owernship registry.
contract Indeed 
{
    mapping(uint16 => address) versions;
    mapping(address => bool) owners;
    uint16 currentVersion;
    
    function getRegistry() public view returns (address _registryAddress)
    {
        return versions[currentVersion];
    }
    
    function getRegistry(uint16 versionNumber) public view returns (address _registryAddress)
    {
        return versions[versionNumber];
    }
    
    function updateVersion(address newAddress) public payable returns (uint16)
    {
        require(owners[msg.sender]);
        
        currentVersion++;
        versions[currentVersion] = newAddress ;
        
        return currentVersion;
    }
    
}
