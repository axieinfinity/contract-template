// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import { AccessControlEnumerable } from "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import { ERC1155Burnable } from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import { ERC1155Pausable } from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import { ERC1155Supply } from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { IERC1155Common } from "./interfaces/IERC1155Common.sol";

abstract contract ERC1155Common is
  ERC1155,
  AccessControlEnumerable,
  ERC1155Pausable,
  ERC1155Burnable,
  ERC1155Supply,
  IERC1155Common
{
  using Strings for uint256;

  bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

  string private _name;
  string private _symbol;

  constructor(address admin, string memory name_, string memory symbol_, string memory uri_) ERC1155(uri_) {
    _grantRole(DEFAULT_ADMIN_ROLE, admin);
    _grantRole(PAUSER_ROLE, admin);
    _grantRole(MINTER_ROLE, admin);
    _grantRole(URI_SETTER_ROLE, admin);

    _name = name_;
    _symbol = symbol_;
  }

  /**
   * @dev Set the URI for all token types.
   * Requirements:
   * - the caller must have the `URI_SETTER_ROLE`.
   */
  function setURI(string memory newURI) external onlyRole(URI_SETTER_ROLE) {
    _setURI(newURI);
  }

  /**
   * @dev Pauses all token transfers.
   * Requirements:
   * - the caller must have the `PAUSER_ROLE`.
   */
  function pause() external onlyRole(PAUSER_ROLE) {
    _pause();
  }

  /**
   * @dev Unpauses all token transfers.
   * Requirements:
   * - the caller must have the `PAUSER_ROLE`.
   */
  function unpause() external onlyRole(PAUSER_ROLE) {
    _unpause();
  }

  /// @inheritdoc IERC1155Common
  function mint(address account, uint256 id, uint256 amount, bytes calldata data) public virtual onlyRole(MINTER_ROLE) {
    _mint(account, id, amount, data);
  }

  /// @inheritdoc IERC1155Common
  function mintBatch(address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data)
    public
    virtual
    onlyRole(MINTER_ROLE)
  {
    _mintBatch(to, ids, amounts, data);
  }

  /**
   * @dev Mint single token to multiple addresses.
   * Requirements:
   * - the caller must have the `MINTER_ROLE`.
   */
  function bulkMint(uint256 id, address[] calldata tos, uint256[] calldata amounts, bytes[] calldata datas)
    public
    virtual
    onlyRole(MINTER_ROLE)
  {
    uint256 length = tos.length;
    require(length == amounts.length, "ERC1155: invalid array lengths");
    require(length == datas.length, "ERC1155: invalid array lengths");

    for (uint256 i; i < length; ++i) {
      _mint(tos[i], id, amounts[i], datas[i]);
    }
  }

  /**
   * @dev See {ERC1155-uri}.
   */
  function uri(uint256 tokenId) public view override returns (string memory) {
    string memory uri_ = super.uri(tokenId);
    return string.concat(uri_, tokenId.toString());
  }

  /**
   * @dev Collection name.
   */
  function name() public view returns (string memory) {
    return _name;
  }

  /**
   * @dev Collection symbol.
   */
  function symbol() public view returns (string memory) {
    return _symbol;
  }

  /**
   * @dev See {ERC165-supportsInterface}.
   */
  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC1155, AccessControlEnumerable)
    returns (bool)
  {
    return interfaceId == type(IERC1155Common).interfaceId || super.supportsInterface(interfaceId);
  }

  /**
   * @dev See {ERC1155-_beforeTokenTransfer}.
   */
  function _beforeTokenTransfer(
    address operator,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) internal virtual override(ERC1155, ERC1155Pausable, ERC1155Supply) {
    super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
  }
}
