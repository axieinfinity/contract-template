// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { ERC1155 } from "../../../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import { AccessControl } from "../../../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import { INFTLaunchpad } from "../../interfaces/launchpad/INFTLaunchpad.sol";

contract SampleNFT1155Launchpad is ERC1155, AccessControl, INFTLaunchpad {
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

  constructor(address admin, address minter, string memory uri_) ERC1155(uri_) {
    _setupRole(DEFAULT_ADMIN_ROLE, admin);
    _setupRole(MINTER_ROLE, minter);
  }

  /// @dev Mint NFTs for the launchpad.
  function mintLaunchpad(address to, uint256 quantity, bytes memory /* extraData */ )
    external
    onlyRole(MINTER_ROLE)
    returns (uint256[] memory tokenIds, uint256[] memory amounts)
  {
    _mint(to, 3, quantity, "");

    tokenIds = new uint256[](1);
    amounts = new uint256[](1);
    tokenIds[0] = 3;
    amounts[0] = quantity;
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
    return interfaceId == type(INFTLaunchpad).interfaceId || super.supportsInterface(interfaceId);
  }
}
