// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract MyERC1155 is ERC1155, Ownable {
    using Address for address;

    mapping(uint256 => uint256) private _totalSupply;
    mapping(uint256 => uint256) private _maxIndex;
    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory uri) ERC1155(uri) {}

    function mintERC20(address tokenAddress, uint256 amount) external onlyOwner {
        require(tokenAddress.isContract(), "ERC20 token address is Invalid");
        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(msg.sender, address(this), amount), "ERC20 transfer failed");
        uint256 id = uint256(tokenAddress);
        _mint(msg.sender, id, amount, "");
        _totalSupply[id] += amount;
        _maxIndex[id] = id;
    }

    function mintERC721(address tokenAddress, uint256 tokenId) external onlyOwner {
        require(tokenAddress.isContract(), "ERC721 token address Invalid");
        IERC721 token = IERC721(tokenAddress);
        require(token.ownerOf(tokenId) == msg.sender, "Not the owner of the token");
        uint256 id = uint256(tokenAddress) | tokenId;
        _mint(msg.sender, id, 1, "");
        _totalSupply[id] += 1;
        _maxIndex[id] = id;
    }

    function balanceOf(address account, uint256 id) public view returns (uint256) {
        return _balanceOf(account, id);
    }

    function totalSupply(uint256 id) public view returns (uint256) {
        return _totalSupply[id];
    }

    function maxIndex(uint256 id) public view returns (uint256) {
        return _maxIndex[id];
    }

    function tokenURI(uint256 id) public view returns (string memory) {
        return _tokenURIs[id];
    }

    function setTokenURI(uint256 id, string memory tokenURI) external onlyOwner {
        _tokenURIs[id] = tokenURI;
    }

    function transferERC20(
        address to,
        address tokenAddress,
        uint256 amount
    ) external {
        require(msg.sender == to || msg.sender == owner(), "Not authorized");
        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(to, amount), "ERC20 transfer failed");
        uint256 id = uint256(tokenAddress);
        _transfer(msg.sender, to, id, amount, "");
    }

    function transferERC721(
        address to,
        address tokenAddress,
        uint256 tokenId
    ) external {
        require(msg.sender == to || msg.sender == owner(), "Not authorized");
        IERC721 token = IERC721(tokenAddress);
        require(token.ownerOf(tokenId) == msg.sender, "Not the owner of the token");
        uint256 id = uint256(tokenAddress) | tokenId;
        _transfer(msg.sender, to, id, 1, "");
    }
}
