// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { SampleNFT1155Launchpad, SampleERC1155 } from "../../src/mock/launchpad/SampleNFT1155Launchpad.sol";
import { INFTLaunchpad } from "src/interfaces/launchpad/INFTLaunchpad.sol";
import { IERC1155Common, IAccessControlEnumerable, IERC1155 } from "src/interfaces/IERC1155Common.sol";

contract SampleERC1155LaunchpadTest is Test {
  using Strings for uint256;

  address admin = makeAddr("admin");
  string public constant NAME = "SampleERC721";
  string public constant SYMBOL = "NFT";
  string public constant BASE_URI = "http://example.com/";

  SampleNFT1155Launchpad internal _t;

  function setUp() public virtual {
    _t = new SampleNFT1155Launchpad(admin, NAME, SYMBOL, BASE_URI);
  }

  function testSupportsInterface() public view {
    assertEq(_token().supportsInterface(type(INFTLaunchpad).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC1155Common).interfaceId), true);
    assertEq(_token().supportsInterface(type(IAccessControlEnumerable).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC1155).interfaceId), true);
  }

  function _token() internal view virtual returns (SampleNFT1155Launchpad) {
    return _t;
  }
}
