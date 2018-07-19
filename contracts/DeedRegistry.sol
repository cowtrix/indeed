pragma solidity ^0.4.16;

contract DeedRegistry 
{
    struct Deed 
    {
        address owner;
        bytes32 identityHash;
        byte[256] fileChecksum;         	// checksum of the file this deed concerns
        uint blockNumber;
    }
    
    mapping(bytes32 => Deed[]) registry;    // Sha3 hash of the larger hash
    
    constructor() public
    {
    }

    // Deed management ==============================================
    
    // Create a new deed with the given fingerprint
    function createDeed(
        string ownerName,
        string fileName,
        string fileDescription,
        byte[256] fileChecksum) external payable returns(uint)
    {
        address ownerAddress = msg.sender;
        
        // Generate the bucket hash of the deed
        bytes32 fileHash = keccak256(abi.encodePacked(fileChecksum));
                
        // Now we create an identity hash. The owner of the deed then should be able to reconstruct this hash with the same details
        bytes32 identityHash = generateIdentityHash(ownerAddress, ownerName, fileName, fileDescription, fileHash);

        // Check for any duplicates in the mapping
        require(searchForDeed(identityHash, fileChecksum).blockNumber == 0);
        
        Deed memory newDeed = Deed(ownerAddress, identityHash, fileChecksum, block.number);
        registry[identityHash].push(newDeed);
        
        return newDeed.blockNumber;
    }

    function generateIdentityHash(
        address ownerAddress,
        string ownerName,
        string fileName,
        string fileDescription,
        bytes32 fileHash) internal pure returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(ownerAddress, ownerName, fileName, fileDescription, fileHash)
        );
    }
    
    function proveDeed(
        address ownerAddress,
        string ownerName,
        string fileName,
        string fileDescription,
        byte[256] fileChecksum) public view returns(uint)
    {
        bytes32 fileHash = keccak256(abi.encodePacked(fileChecksum));
        bytes32 identityHash = generateIdentityHash(ownerAddress, ownerName, fileName, fileDescription, fileHash);
        return searchForDeed(identityHash, fileChecksum).blockNumber;
    }
    
    function searchForDeed(bytes32 identityHash, byte[256] fileChecksum) internal view returns (Deed result)
    {
        Deed[] storage bucket = registry[identityHash];
        for(uint i = 0; i < bucket.length; ++i)
        {
            Deed memory deed = bucket[i];
            bool matchFound = true;
            for(uint j = 0; j < 256; ++j)
            {
                if(deed.fileChecksum[j] != fileChecksum[j])
                {
                    matchFound = false;
                    break;
                }
            }
            if(matchFound)
            {
                result = deed;
                break;
            }
        }
        return result;
    }
}
