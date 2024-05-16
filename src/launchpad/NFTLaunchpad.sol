// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { ERC165 } from "../../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";

import { INFTLaunchpad } from "../interfaces/launchpad/INFTLaunchpad.sol";

abstract contract NFTLaunchpad is ERC165, INFTLaunchpad {
  function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return interfaceId == type(INFTLaunchpad).interfaceId || super.supportsInterface(interfaceId);
  }
}
