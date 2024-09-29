// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title ERC721Nonce
 * @dev This contract provides a nonce that will be increased whenever the token is transferred.
 */
abstract contract ERC721Nonce is ERC721 {
  /// @dev Emitted when the token nonce is updated
  event NonceUpdated(uint256 indexed _tokenId, uint256 indexed _nonce);

  /// @dev Mapping from token id => token nonce
  mapping(uint256 => uint256) public nonces;

  /**
   * @dev This empty reserved space is put in place to allow future versions to add new
   * variables without shifting down storage in the inheritance chain.
   */
  uint256[50] private ______gap;

  /**
   * @dev Override `ERC721-_update`.
   */
  function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
    emit NonceUpdated(tokenId, ++nonces[tokenId]);
    return super._update(to, tokenId, auth);
  }
}
