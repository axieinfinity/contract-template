// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {ERC1155Common} from "../Erc1155Common.sol";
import {INFTLaunchpad} from "../refs/INFTLaunchpad.sol";

contract Erc1155DangDang is ERC1155Common, INFTLaunchpad {
  constructor(string memory name, string memory symbol, string memory baseTokenURI, address[] memory minters)
    ERC1155Common(name, symbol, baseTokenURI, minters)
  {}

  function mintLaunchpad(address to, uint256 quantity, bytes memory /* extraData */ )
    external
    returns (uint256[] memory tokenIds, uint256[] memory amounts)
  {
    _mint(to, 6, quantity, "");

    tokenIds = new uint256[](1);
    amounts = new uint256[](1);
    tokenIds[0] = 6;
    amounts[0] = quantity;
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return interfaceId == type(INFTLaunchpad).interfaceId || super.supportsInterface(interfaceId);
  }
}
