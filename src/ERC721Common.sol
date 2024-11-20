// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./interfaces/IERC721State.sol";
import "./interfaces/IERC721Common.sol";
import "./refs/ERC721Nonce.sol";
import "./ERC721PresetMinterPauserAutoIdCustomized.sol";

contract ERC721Common is ERC721Nonce, ERC721PresetMinterPauserAutoIdCustomized, IERC721State, IERC721Common {
  constructor(string memory name, string memory symbol, string memory baseTokenURI)
    ERC721PresetMinterPauserAutoIdCustomized(name, symbol, baseTokenURI)
  { }

  /// @inheritdoc IERC721State
  function stateOf(uint256 _tokenId) external view virtual override returns (bytes memory) {
    require(_exists(_tokenId), "ERC721Common: query for non-existent token");
    return abi.encodePacked(ownerOf(_tokenId), nonces[_tokenId], _tokenId);
  }

  /**
   * @dev Override `ERC721-_baseURI`.
   */
  function _baseURI()
    internal
    view
    virtual
    override(ERC721, ERC721PresetMinterPauserAutoIdCustomized)
    returns (string memory)
  {
    return super._baseURI();
  }

  /**
   * @dev Override `IERC165-supportsInterface`.
   */
  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721, ERC721PresetMinterPauserAutoIdCustomized)
    returns (bool)
  {
    return interfaceId == type(IERC721Common).interfaceId || interfaceId == type(IERC721State).interfaceId
      || super.supportsInterface(interfaceId);
  }

  /**
   * @dev Override `ERC721PresetMinterPauserAutoIdCustomized-_beforeTokenTransfer`.
   */
  function _beforeTokenTransfer(address _from, address _to, uint256 _firstTokenId, uint256 _batchSize)
    internal
    virtual
    override(ERC721Nonce, ERC721PresetMinterPauserAutoIdCustomized)
  {
    super._beforeTokenTransfer(_from, _to, _firstTokenId, _batchSize);
  }

  /**
   * @dev Bulk create new tokens for `_recipients`. Tokens ID will be automatically
   * assigned (and available on the emitted {IERC721-Transfer} event), and the token
   * URI autogenerated based on the base URI passed at construction.
   *
   * See {ERC721-_mint}.
   *
   * Requirements:
   *
   * - the caller must have the `MINTER_ROLE`.
   */
  function bulkMint(address[] calldata _recipients)
    external
    virtual
    onlyRole(MINTER_ROLE)
    returns (uint256[] memory _tokenIds)
  {
    require(_recipients.length > 0, "ERC721Common: invalid array lengths");
    _tokenIds = new uint256[](_recipients.length);

    for (uint256 _i = 0; _i < _recipients.length; _i++) {
      _tokenIds[_i] = _mintFor(_recipients[_i]);
    }
  }
}
