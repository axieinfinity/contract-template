// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { NFTLaunchpadCommon } from "../../launchpad/NFTLaunchpadCommon.sol";
import { SampleERC1155, ERC1155Common } from "../SampleERC1155.sol";

contract SampleNFT1155Launchpad is SampleERC1155, NFTLaunchpadCommon {
  constructor(address admin, string memory name, string memory symbol, string memory uri)
    SampleERC1155(admin, name, symbol, uri)
  { }

  /// @dev Mint NFTs for the launchpad.
  function mintLaunchpad(
    address to,
    uint256 quantity,
    bytes calldata /* extraData */
  ) external onlyRole(MINTER_ROLE) returns (uint256[] memory tokenIds, uint256[] memory amounts) {
    _mint(to, 3, quantity, "");
    _mint(to, 4, 1, "");

    tokenIds = new uint256[](2);
    amounts = new uint256[](2);
    tokenIds[0] = 3;
    tokenIds[1] = 4;

    amounts[0] = quantity;
    amounts[1] = 1;
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC1155Common, NFTLaunchpadCommon)
    returns (bool)
  {
    return ERC1155Common.supportsInterface(interfaceId) || NFTLaunchpadCommon.supportsInterface(interfaceId);
  }
}
