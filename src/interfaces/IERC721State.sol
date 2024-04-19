// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC721State {
  /**
   * @dev Returns the state of the `_tokenId` ERC721.
   *
   * Requirements:
   *
   * - The token exists.
   *
   * @notice The token state presents the properties of a token at a certain point in time, it should be unique.
   * The token state helps other contracts can verify the token properties without getting and selecting properties from the base contract.
   *
   * For example:
   *
   * ```solidity
   * contract Kitty {
   *   function stateOf(uint256 _tokenId) external view returns (bytes memory) {
   *     return abi.encodePacked(ownerOf(_tokenId), genesOf(_tokenId), levelOf(_tokenId));
   *   }
   * }
   *
   * interface Exchange {
   *   // Buy NFT with the specificed state of `_tokenId`.
   *   function buy(uint256 _tokenId, uint256 _price, bytes calldata _kittyState) external;
   * }
   * ```
   */
  function stateOf(uint256 _tokenId) external view returns (bytes memory);
}
