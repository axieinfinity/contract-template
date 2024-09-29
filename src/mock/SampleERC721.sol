// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { ERC721Common } from "../ERC721Common.sol";

contract SampleERC721 is ERC721Common {
  constructor(
    string memory name_,
    string memory symbol_,
    string memory baseTokenURI
  ) ERC721Common(name_, symbol_, baseTokenURI) { }
}
