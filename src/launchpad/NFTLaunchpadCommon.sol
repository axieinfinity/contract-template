// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { IERC165 } from "@openzeppelin/contracts/interfaces/IERC165.sol";

import { INFTLaunchpad } from "../interfaces/launchpad/INFTLaunchpad.sol";

abstract contract NFTLaunchpadCommon is IERC165, INFTLaunchpad {
  /// @dev Returns whether the contract supports the NFT launchpad interface.
  function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return interfaceId == type(INFTLaunchpad).interfaceId || super.supportsInterface(interfaceId);
  }
}
