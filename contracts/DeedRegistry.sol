pragma solidity ^0.4.16;

contract DeedRegistry {

    function DeedRegistry() public {
        registrars[msg.sender] = true;
    }

    struct Deed {
        address owner;
        bytes32 identityHash;
        byte[256] fileChecksum;         	// checksum of the file this deed concerns
    }
    
    mapping(bytes32 => Deed[]) registry;    // Sha3 hash of the larger hash
    mapping(address => bool) registrars;    // The authorised addresses for adding elements to the registry
    
    
    // Registrar management =========================================
    function isRegistrar(address registrarAddress) public view returns (bool) {
        return registrars[registrarAddress];
    }
	
    function addRegistrar(address registrarAddress) public {
        require(registrars[msg.sender]);
        registrars[registrarAddress] = true;
    }
    
    function removeRegistrar(address registrarAddress) public {
        require(registrars[msg.sender]);
        delete registrars[registrarAddress];
    }
    
    // Deed management ==============================================
    
    // Create a new deed with the given fingerprint
    function createDeed(
        address ownerAddress,
        string ownerName, 
        int64 ownerDOB,
        string fileName,
        uint filesize,
        string fileDescription,
        byte[256] fileChecksum) external payable returns(bool)
    {
        // Require that the caller is an approved registrar
        require(registrars[msg.sender]);    
        
        // Generate the bucket hash of the deed
        bytes32 fileHash = keccak256(fileChecksum);
        
        // Check for any duplicates in the mapping
        require(!duplicateHashExists(fileHash, fileChecksum));
        
        // Now we create an block number dependent identity hash. The owner of the deed then should be able to reconstruct
        // the hash data from the contract call
        bytes32 identityHash = keccak256(ownerAddress, ownerName, ownerDOB, fileName, filesize, fileDescription, fileHash, block.number);
        
        Deed memory newDeed = Deed(ownerAddress, identityHash, fileChecksum);
        registry[fileHash].push(newDeed);
        
        return true;
    }
    
    function deedExists(byte[256] fileChecksum) public view returns(bool) {
        bytes32 fileHash = keccak256(fileChecksum);
        return duplicateHashExists(fileHash, fileChecksum);
    }
    
    function duplicateHashExists(bytes32 hash, byte[256] fileChecksum) internal view returns (bool duplicateFound) {
        Deed[] storage bucket = registry[hash];
        if ( bucket.length > 0) {
            for (uint i = 0; i < bucket.length; ++i) {
                duplicateFound = true;
                Deed memory deed = bucket[i];
                for (uint j = 0; j < 256; ++j) {
                    if (deed.fileChecksum[j] != fileChecksum[j]) {
                        duplicateFound = false;
                        break;
                    }
                }
                if (duplicateFound) {
                    break;
                }
            }
        }
        return duplicateFound;
    }
}
