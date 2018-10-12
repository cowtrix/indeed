pragma solidity ^0.4.16;

contract DeedRegistry 
{
    uint constant MAX_UINT = 2**53-1;

    struct Deed 
    {
        address owner;          // The address that created this deed
        bytes32 identityHash;   // The hash of the identity details that created this deed
        uint256 fileChecksum;   // Checksum of the file this deed concerns
        uint blockNumber;       // The number of the block when this deed was created (for dating and chronology)
    }
    
    mapping(bytes32 => Deed[]) registry;    // This is a mapping of the idneitity hash (see below) to the Deed
    event DeedCreated(uint blockNumber);    // Event for deed creation, returns the block number containing the Deed transaction
  
    // Create a new deed with the given fingerprint. Input identity details are arbitrary - only the user requires knowledge of them.
    // Returns: the block number containing the new Deed transaction
    function createDeed(
        string ownerName,
        string fileName,
        string fileDescription,
        uint256 fileChecksum) external payable returns(uint)
    {
        address ownerAddress = msg.sender;
        
        // Generate the bucket hash of the deed
        bytes32 fileHash = keccak256(abi.encodePacked(fileChecksum));
                
        // Now we create an identity hash. The owner of the deed then should be able to reconstruct this hash with the same details
        bytes32 identityHash = generateIdentityHash(ownerAddress, ownerName, fileName, fileDescription, fileHash);

        // Now we search for an existing deed with this identity hash and checksum combination.
        // OPEN QUESTION: why do we care about duplicates? Worst case, you can prove owning the same file multiple times. 
        // However - if multiple deeds exist with the same identity, we need to have some rule...
        // For now, let's say that it just returns the earliest block number with the given deed.
        // require(searchForDeed(identityHash, fileChecksum).blockNumber != 0);
        
        Deed memory newDeed = Deed(ownerAddress, identityHash, fileChecksum, block.number);
        registry[identityHash].push(newDeed);
        emit DeedCreated(newDeed.blockNumber);
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
        uint256 fileChecksum,
        uint targetBlock) public view returns(uint)
    {
        bytes32 fileHash = keccak256(abi.encodePacked(fileChecksum));
        bytes32 identityHash = generateIdentityHash(ownerAddress, ownerName, fileName, fileDescription, fileHash);
        return searchForDeed(identityHash, fileChecksum, targetBlock).blockNumber;
    }
    
    function searchForDeed(bytes32 identityHash, uint256 fileChecksum, uint targetBlockNumber) private view returns (Deed result)
    {
        uint earliestBlock = MAX_UINT;
        for(uint i = 0; i < registry[identityHash].length; ++i)
        {
            if(registry[identityHash][i].fileChecksum == fileChecksum)
            {
                // If we haven't set a target, return the earliest block
                if(targetBlockNumber == 0 && registry[identityHash][i].blockNumber < earliestBlock)
                {
                    result = registry[identityHash][i];
                    earliestBlock = result.blockNumber;
                }
                // Alternatively, we've specified a target block number, so if we find that, immediately return
                else if(registry[identityHash][i].blockNumber == targetBlockNumber)
                {
                    result = registry[identityHash][i];
                    break;
                }
            }
            
        }
        return result;
    }
}
