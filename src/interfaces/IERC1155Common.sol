// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { IAccessControlEnumerable } from "@openzeppelin/contracts/access/extensions/IAccessControlEnumerable.sol";
import { IERC1155 } from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface IERC1155Common is IAccessControlEnumerable, IERC1155 {
  /// @dev Return the name of the collection.
  function name() external view returns (string memory);

  /// @dev Return the symbol of the collection.
  function symbol() external view returns (string memory);

  /**
   * @dev Mints a single ERC1155 token and assigns it to the specified address.
   *
   * Requirements:
   * - the caller must have the `MINTER_ROLE`.
   *
   * @param to The address to which the minted token will be assigned.
   * @param id The ID of the token to mint.
   * @param amount The amount of tokens to mint.
   * @param data Additional data with no specified format.
   */
  function mint(address to, uint256 id, uint256 amount, bytes calldata data) external;

  /**
   * @dev Mints multiple ERC1155 tokens and assigns them to the specified address.
   *
   * Requirements:
   * - the caller must have the `MINTER_ROLE`.
   *
   * @param to The address to which the minted tokens will be assigned.
   * @param ids The IDs of the tokens to mint.
   * @param amounts The amounts of tokens to mint.
   * @param data Additional data with no specified format.
   */
  function mintBatch(address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;

  /**
   * @dev Mint single token to multiple addresses.
   * Requirements:
   * - the caller must have the `MINTER_ROLE`.
   *
   * @param id The ID of the token to mint.
   * @param tos The addresses to which the minted tokens will be assigned.
   * @param amounts The amounts of tokens to mint.
   * @param datas Additional data with no specified format.
   */
  function bulkMint(uint256 id, address[] calldata tos, uint256[] calldata amounts, bytes[] calldata datas) external;
}
