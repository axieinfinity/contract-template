// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/// @dev Interface for the NFT contract that compatible with the NFT launchpad.
/// MUST be included ERC165 interface to support the detection of the contract's capabilities.
interface INFTLaunchpad {
  /**
   * @dev Mint NFTs for the launchpad.
   * @param to The address to mint the NFTs to.
   * @param quantity The quantity of NFTs to mint.
   * @param extraData The extra data for minting NFTs.
   * @return mintedTokenIds The token IDs of the minted NFTs.
   * @return mintedAmounts The minted amounts by token ID.
   */
  function mintLaunchpad(address to, uint256 quantity, bytes memory extraData)
    external
    returns (uint256[] memory mintedTokenIds, uint256[] memory mintedAmounts);
}
