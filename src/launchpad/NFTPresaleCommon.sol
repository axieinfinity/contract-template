// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { IERC165 } from "@openzeppelin/contracts/interfaces/IERC165.sol";

import { INFTPresale } from "../interfaces/launchpad/INFTPresale.sol";

abstract contract NFTPresaleCommon is IERC165, INFTPresale {
  /// @dev Returns whether the contract supports the NFT presale interface.
  function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
    return interfaceId == type(INFTPresale).interfaceId || interfaceId == type(IERC165).interfaceId;
  }
}
