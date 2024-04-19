// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC721Upgradeable } from
  "../../../lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";

/**
 * @title ERC721NonceUpgradeable
 * @dev This contract provides a nonce that will be increased whenever the token is tranferred.
 */
abstract contract ERC721NonceUpgradeable is ERC721Upgradeable {
  /// @dev Emitted when the token nonce is updated
  event NonceUpdated(uint256 indexed tokenId, uint256 indexed nonce);

  /// @dev Mapping from token id => token nonce.
  mapping(uint256 => uint256) private _nonceOf;

  /**
   * @dev This empty reserved space is put in place to allow future versions to add new
   * variables without shifting down storage in the inheritance chain.
   */
  uint256[50] private ______gap;

  function nonces(uint256 tokenId) public view returns (uint256) {
    return _nonceOf[tokenId];
  }

  /**
   * @dev Override `ERC721Upgradeable-_beforeTokenTransfer`.
   */
  function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)
    internal
    virtual
    override
  {
    uint256 length = firstTokenId + batchSize;
    unchecked {
      for (uint256 tokenId = firstTokenId; tokenId < length; ++tokenId) {
        emit NonceUpdated(tokenId, ++_nonceOf[tokenId]);
      }

      super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }
  }
}
