// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../ERC1155Common.sol";

contract SampleERC1155 is ERC1155Common {
  constructor(address admin, string memory name, string memory symbol, string memory uri)
    ERC1155Common(admin, name, symbol, uri)
  { }
}
