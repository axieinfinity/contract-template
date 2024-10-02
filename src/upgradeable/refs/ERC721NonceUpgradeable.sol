// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ERC721Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

/**
 * @title ERC721NonceUpgradeable
 * @dev This contract provides a nonce that will be increased whenever the token is transferred.
 */
abstract contract ERC721NonceUpgradeable is ERC721Upgradeable {
  /// @dev Emitted when the token nonce is updated
  event NonceUpdated(uint256 indexed tokenId, uint256 indexed nonce);

  /// @dev Mapping from token id => token nonce.
  mapping(uint256 tokenId => uint256 nonce) private _nonceOf;

  /**
   * @dev This empty reserved space is put in place to allow future versions to add new
   * variables without shifting down storage in the inheritance chain.
   */
  uint256[50] private __gap;

  function nonces(
    uint256 tokenId
  ) public view returns (uint256) {
    return _nonceOf[tokenId];
  }

  /**
   * @dev Override `ERC721Upgradeable-_update`.
   */
  function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address from) {
    unchecked {
      emit NonceUpdated(tokenId, ++_nonceOf[tokenId]);
      return super._update(to, tokenId, auth);
    }
  }
}
