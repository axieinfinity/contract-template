// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { ERC721PresetMinterPauserAutoIdCustomized } from "./ERC721PresetMinterPauserAutoIdCustomized.sol";
import { IERC721Common } from "./interfaces/IERC721Common.sol";
import { IERC721State } from "./interfaces/IERC721State.sol";
import { ERC721Nonce } from "./refs/ERC721Nonce.sol";
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721Common is ERC721Nonce, ERC721PresetMinterPauserAutoIdCustomized, IERC721State, IERC721Common {
  constructor(string memory name, string memory symbol, string memory baseTokenURI)
    ERC721PresetMinterPauserAutoIdCustomized(name, symbol, baseTokenURI)
  { }

  /// @inheritdoc IERC721State
  function stateOf(
    uint256 tokenId
  ) external view virtual override returns (bytes memory) {
    _requireOwned(tokenId);
    return abi.encodePacked(ownerOf(tokenId), nonces[tokenId], tokenId);
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
  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override(ERC721, ERC721PresetMinterPauserAutoIdCustomized) returns (bool) {
    return interfaceId == type(IERC721Common).interfaceId || interfaceId == type(IERC721State).interfaceId
      || super.supportsInterface(interfaceId);
  }

  /**
   * @dev Override `ERC721PresetMinterPauserAutoIdCustomized-_update`.
   */
  function _update(
    address to,
    uint256 tokenId,
    address auth
  ) internal virtual override(ERC721Nonce, ERC721PresetMinterPauserAutoIdCustomized) returns (address from) {
    return super._update(to, tokenId, auth);
  }

  /**
   * @dev See {ERC721-_increaseBalance}.
   */
  function _increaseBalance(
    address account,
    uint128 amount
  ) internal virtual override(ERC721, ERC721PresetMinterPauserAutoIdCustomized) {
    super._increaseBalance(account, amount);
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
  function bulkMint(
    address[] calldata _recipients
  ) external virtual onlyRole(MINTER_ROLE) returns (uint256[] memory tokenIds) {
    require(_recipients.length > 0, "ERC721Common: invalid array lengths");
    tokenIds = new uint256[](_recipients.length);

    for (uint256 _i = 0; _i < _recipients.length; _i++) {
      tokenIds[_i] = _mintFor(_recipients[_i]);
    }
  }
}
