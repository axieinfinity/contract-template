// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/// @dev Interface for the NFT contract that compatible with the NFT launchpad.
/// MUST be included ERC165 interface to support the detection of the contract's capabilities.
interface INFTLaunchpad {
  /**
   * @dev Mint NFTs for the launchpad.
   *
   * Requirements:
   * 	- The mintedTokenIds and mintedAmounts should have the same length.
   * 	- For ERC721 NFTs, each minted token's quantity should always be 1.
   * 	- For ERC1155 NFTs, each minted token's quantity should be actual minted amounts.
   * Example:
   * 	- ERC1155: If mintedTokenIds = [1, 2], then mintedAmounts = [10, 20]
   * 	- ERC721: If mintedTokenIds = [1, 2], then mintedAmounts = [1, 1]
   *
   * @param to The address to mint the NFTs to.
   * @param quantity The quantity of NFTs to mint.
   * @param extraData The extra data for further customization.
   * @return mintedTokenIds The token IDs of the minted NFTs.
   * @return mintedAmounts The minted amounts according to the `mintedTokenIds`.
   */
  function mintLaunchpad(address to, uint256 quantity, bytes memory extraData)
    external
    returns (uint256[] memory mintedTokenIds, uint256[] memory mintedAmounts);
}
