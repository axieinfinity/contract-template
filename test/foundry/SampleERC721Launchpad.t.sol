// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { SampleERC721Launchpad } from "../../src/mock/launchpad/SampleERC721Launchpad.sol";
import { INFTLaunchpad } from "src/interfaces/launchpad/INFTLaunchpad.sol";
import { IERC721Common } from "src/interfaces/IERC721Common.sol";

contract SampleERC721LaunchpadTest is Test {
  using Strings for uint256;

  string public constant NAME = "SampleERC721";
  string public constant SYMBOL = "NFT";
  string public constant BASE_URI = "http://example.com/";

  SampleERC721Launchpad internal _t;

  function setUp() public virtual {
    _t = new SampleERC721Launchpad(NAME, SYMBOL, BASE_URI);
  }

  function testSupportInterface() public view {
    assertEq(_token().supportsInterface(type(INFTLaunchpad).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC721Common).interfaceId), true);
  }

  function _token() internal view virtual returns (SampleERC721Launchpad) {
    return _t;
  }
}
