// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { SampleERC721 } from "../SampleERC721.sol";

import { ERC721Common } from "../../ERC721Common.sol";
import { NFTPresaleCommon } from "../../launchpad/NFTPresaleCommon.sol";
import { SampleERC721 } from "../SampleERC721.sol";

contract SampleNFT721Presale is SampleERC721, NFTPresaleCommon {
  constructor(string memory name_, string memory symbol_, string memory uri_) SampleERC721(name_, symbol_, uri_) { }

  /// @dev Mint NFTs for the presale.
  function mintPresale(
    address to,
    uint256 quantity,
    bytes calldata /* extraData */
  ) external onlyRole(MINTER_ROLE) returns (uint256[] memory tokenIds, uint256[] memory amounts) {
    tokenIds = new uint256[](quantity);
    amounts = new uint256[](quantity);
    for (uint256 i; i < quantity; ++i) {
      tokenIds[i] = _mintFor(to);
      amounts[i] = 1;
    }
  }

  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override(ERC721Common, NFTPresaleCommon) returns (bool) {
    return ERC721Common.supportsInterface(interfaceId) || NFTPresaleCommon.supportsInterface(interfaceId);
  }
}
