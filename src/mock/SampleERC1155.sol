// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../ERC1155Common.sol";

contract SampleERC1155 is ERC1155Common {
  constructor(string memory name, string memory symbol, string memory baseTokenURI, address[] memory minters)
    ERC1155Common(name, symbol, baseTokenURI, minters)
  {}
}
