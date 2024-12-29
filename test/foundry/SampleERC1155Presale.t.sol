// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { SampleERC1155, SampleERC1155Presale } from "../../src/mock/launchpad/SampleERC1155Presale.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import "forge-std/Test.sol";

import { IAccessControlEnumerable, IERC1155, IERC1155Common } from "src/interfaces/IERC1155Common.sol";
import { INFTPresale } from "src/interfaces/launchpad/INFTPresale.sol";

contract SampleERC1155PresaleTest is Test {
  using Strings for uint256;

  address admin = makeAddr("admin");
  string public constant NAME = "SampleERC721";
  string public constant SYMBOL = "NFT";
  string public constant BASE_URI = "http://example.com/";

  SampleERC1155Presale internal _t;

  function setUp() public virtual {
    _t = new SampleERC1155Presale(admin, NAME, SYMBOL, BASE_URI);
  }

  function testSupportsInterface() public view {
    assertEq(_token().supportsInterface(type(INFTPresale).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC1155Common).interfaceId), true);
    assertEq(_token().supportsInterface(type(IAccessControlEnumerable).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC1155).interfaceId), true);
  }

  function _token() internal view virtual returns (SampleERC1155Presale) {
    return _t;
  }
}
