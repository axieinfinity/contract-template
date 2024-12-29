// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { SampleERC721Presale } from "../../src/mock/launchpad/SampleERC721Presale.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import "forge-std/Test.sol";

import { IERC721Common } from "src/interfaces/IERC721Common.sol";
import { INFTPresale } from "src/interfaces/launchpad/INFTPresale.sol";

contract SampleERC721PresaleTest is Test {
  using Strings for uint256;

  string public constant NAME = "SampleERC721";
  string public constant SYMBOL = "NFT";
  string public constant BASE_URI = "http://example.com/";

  SampleERC721Presale internal _t;

  function setUp() public virtual {
    _t = new SampleERC721Presale(NAME, SYMBOL, BASE_URI);
  }

  function testSupportInterface() public view {
    assertEq(_token().supportsInterface(type(INFTPresale).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC721Common).interfaceId), true);
  }

  function _token() internal view virtual returns (SampleERC721Presale) {
    return _t;
  }
}
