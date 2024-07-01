// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import {AccessControlEnumerable} from "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Common is AccessControlEnumerable, ERC1155, ERC1155Supply {
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

  /**
   * @dev Mints a single ERC1155 token and assigns it to the specified address.
   * @param to The address to which the minted token will be assigned.
   * @param id The ID of the token to mint.
   * @param amount The amount of tokens to mint.
   */
  function mint(address to, uint256 id, uint256 amount) external onlyRole(MINTER_ROLE) {
    _mint(to, id, amount, "");
  }

  /**
   * @dev Mints multiple ERC1155 tokens and assigns them to the specified address.
   * @param to The address to which the minted tokens will be assigned.
   * @param ids The IDs of the tokens to mint.
   * @param amounts The amounts of tokens to mint.
   */
  function batchMint(address to, uint256[] calldata ids, uint256[] calldata amounts) external onlyRole(MINTER_ROLE) {
    _mintBatch(to, ids, amounts, "");
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC1155, AccessControlEnumerable) returns (bool) {
    return super.supportsInterface(interfaceId);
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
