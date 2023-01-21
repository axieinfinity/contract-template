// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../ERC721Common.sol";

contract SampleERC721 is ERC721Common {
  constructor(string memory name, string memory symbol, string memory baseTokenURI)
    ERC721Common(name, symbol, baseTokenURI)
  {}
}
