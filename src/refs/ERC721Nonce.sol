// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title ERC721Nonce
 * @dev This contract provides a nonce that will be increased whenever the token is tranferred.
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
   * @dev Override `ERC721-_beforeTokenTransfer`.
   */
  function _beforeTokenTransfer(address _from, address _to, uint256 _firstTokenId, uint256 _batchSize)
    internal
    virtual
    override
  {
    for (uint256 _tokenId = _firstTokenId; _tokenId < _firstTokenId + _batchSize; _tokenId++) {
      emit NonceUpdated(_tokenId, ++nonces[_tokenId]);
    }
    super._beforeTokenTransfer(_from, _to, _firstTokenId, _batchSize);
  }
}
