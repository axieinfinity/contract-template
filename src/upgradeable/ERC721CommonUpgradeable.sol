// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ERC721Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import { IERC721State } from "../interfaces/IERC721State.sol";
import { IERC721Common } from "../interfaces/IERC721Common.sol";
import { ERC721NonceUpgradeable } from "./refs/ERC721NonceUpgradeable.sol";
import { ERC721PresetMinterPauserAutoIdCustomizedUpgradeable } from
  "./ERC721PresetMinterPauserAutoIdCustomizedUpgradeable.sol";

abstract contract ERC721CommonUpgradeable is
  ERC721NonceUpgradeable,
  ERC721PresetMinterPauserAutoIdCustomizedUpgradeable,
  IERC721State,
  IERC721Common
{
  error ErrInvalidArrayLength();
  error ErrNonExistentToken();

  /**
   * @dev This empty reserved space is put in place to allow future versions to add new
   * variables without shifting down storage in the inheritance chain.
   */
  uint256[50] private __gap;

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  /// @inheritdoc IERC721State
  function stateOf(uint256 tokenId) external view virtual override returns (bytes memory) {
    if (!_exists(tokenId)) revert ErrNonExistentToken();
    return abi.encodePacked(ownerOf(tokenId), nonces(tokenId), tokenId);
  }

  /// @inheritdoc IERC721Common
  function bulkMint(address[] calldata recipients)
    external
    virtual
    onlyRole(MINTER_ROLE)
    returns (uint256[] memory tokenIds)
  {
    uint256 length = recipients.length;
    if (length == 0) revert ErrInvalidArrayLength();
    tokenIds = new uint256[](length);

    for (uint256 i; i < length; ++i) {
      tokenIds[i] = _mintFor(recipients[i]);
    }
  }

  /**
   * @dev Override `IERC165-supportsInterface`.
   */
  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721Upgradeable, ERC721PresetMinterPauserAutoIdCustomizedUpgradeable)
    returns (bool)
  {
    return interfaceId == type(IERC721State).interfaceId || interfaceId == type(IERC721Common).interfaceId
      || super.supportsInterface(interfaceId);
  }

  /**
   * @dev Override `ERC721Upgradeable-_baseURI`.
   */
  function _baseURI()
    internal
    view
    virtual
    override(ERC721Upgradeable, ERC721PresetMinterPauserAutoIdCustomizedUpgradeable)
    returns (string memory)
  {
    return super._baseURI();
  }

  /**
   * @dev Override `ERC721PresetMinterPauserAutoIdCustomizedUpgradeable-_beforeTokenTransfer`.
   */
  function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)
    internal
    virtual
    override(ERC721NonceUpgradeable, ERC721PresetMinterPauserAutoIdCustomizedUpgradeable)
  {
    super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
  }
}
