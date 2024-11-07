// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import { ERC1155Supply } from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import { AccessControlEnumerable } from "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { IERC1155Common } from "./interfaces/IERC1155Common.sol";

contract ERC1155Common is AccessControlEnumerable, ERC1155, ERC1155Supply, IERC1155Common {
  using Strings for uint256;

  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  string private _name;
  string private _symbol;

  constructor(string memory name_, string memory symbol_, string memory baseTokenURI, address[] memory minters)
    payable
    ERC1155(baseTokenURI)
  {
    _name = name_;
    _symbol = symbol_;
    _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    bytes32 minterRole = MINTER_ROLE;

    uint256 length = minters.length;
    for (uint256 i; i < length;) {
      _grantRole(minterRole, minters[i]);
      unchecked {
        ++i;
      }
    }
  }

  function uri(uint256 tokenId) public view override returns (string memory) {
    string memory _uri = super.uri(tokenId);
    return string(abi.encodePacked(_uri, tokenId.toString()));
  }

  function name() external view returns (string memory) {
    return _name;
  }

  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
   * @dev Sets the base URI for metadata of ERC1155 tokens.
   * @param uri_ The new base URI.
   */
  function setURI(string calldata uri_) external onlyRole(DEFAULT_ADMIN_ROLE) {
    _setURI(uri_);
  }

  /// @inheritdoc IERC1155Common
  function mint(address to, uint256 id, uint256 amount) external onlyRole(MINTER_ROLE) {
    _mint(to, id, amount, "");
  }

  /// @inheritdoc IERC1155Common
  function batchMint(address to, uint256[] calldata ids, uint256[] calldata amounts) external onlyRole(MINTER_ROLE) {
    _mintBatch(to, ids, amounts, "");
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC1155, AccessControlEnumerable) returns (bool) {
    return interfaceId == type(IERC1155Common).interfaceId || super.supportsInterface(interfaceId);
  }

  function _beforeTokenTransfer(
    address operator,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) internal virtual override(ERC1155, ERC1155Supply) {
    super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
  }
}
