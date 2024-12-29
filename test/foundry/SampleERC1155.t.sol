// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { SampleERC1155, ERC1155Common } from "../../src/mock/SampleERC1155.sol";
import { IERC165 } from "@openzeppelin/contracts/interfaces/IERC165.sol";
import { IERC1155 } from "@openzeppelin/contracts/interfaces/IERC1155.sol";
import { IAccessControlEnumerable } from "@openzeppelin/contracts/access/IAccessControlEnumerable.sol";
import { IERC1155Common } from "src/interfaces/IERC1155Common.sol";

contract SampleERC1155Test is Test {
  using Strings for uint256;

  string public constant NAME = "SampleERC1155";
  string public constant SYMBOL = "NFT1155";
  string public constant BASE_URI = "http://example.com/";
  address admin = makeAddr("admin");

  ERC1155Common internal _t;

  function setUp() public virtual {
    _t = new SampleERC1155(admin, NAME, SYMBOL, BASE_URI);
  }

  function testName() public virtual {
    assertEq(_token().name(), NAME);
  }

  function testSymbol() public virtual {
    assertEq(_token().symbol(), SYMBOL);
  }

  function testURI(address _from) public virtual {
    vm.assume(_from.code.length == 0 && _from != address(0));
    assertEq(_token().uri(uint256(50)), string(abi.encodePacked(BASE_URI, uint256(50).toString())));
  }

  function testMint() public virtual {
    vm.startPrank(admin);
    _token().mint(address(15), 15, 15, "");
    assertEq(_token().totalSupply(15), 15);
    assertEq(_token().balanceOf(address(15), 15), 15);

    _token().mint(address(20), 15, 15, "");
    assertEq(_token().totalSupply(15), 30);
    assertEq(_token().balanceOf(address(20), 15), 15);
    vm.stopPrank();
  }

  function testSupportsInterface() public virtual {
    assertEq(_token().supportsInterface(type(IERC1155).interfaceId), true);
    assertEq(_token().supportsInterface(type(IAccessControlEnumerable).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC1155Common).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC165).interfaceId), true);
  }

  function _token() internal view virtual returns (ERC1155Common) {
    return _t;
  }
}
