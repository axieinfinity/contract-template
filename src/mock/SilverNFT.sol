// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "../ERC721Common.sol";

contract DangDang006 is ERC721Common {
  constructor(string memory name, string memory symbol, string memory baseTokenURI)
    ERC721Common(name, symbol, baseTokenURI)
  {}

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    return string(abi.encodePacked(_baseURI(), Strings.toString(_tokenId % 10))); // Demo only has 10 metadata
  }
}
