// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721URIStorage {
    // Keep track of the token IDs
    uint256 private _tokenId;

    // Initialize the contract with the name and symbol of the token
    constructor() ERC721("MyNFT", "MNFT") {}

    // Override the _burn function to use the ERC721URIStorage implementation
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
    }

    // Override the tokenURI function to use the ERC721URIStorage implementation
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // Mint a new token with a given URI and assign it to a given address
    function mint(address to, string memory uri) public returns (uint256) 
    {
    // Increment the token ID and store it
    _tokenId++;
    uint256 tokenId = _tokenId;

    // Mint the token and set its URI
    _mint(to, tokenId);
    _setTokenURI(tokenId, uri);

    // Return the new token ID
    return tokenId;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

