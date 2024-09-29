// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { IAccessControlEnumerable } from "@openzeppelin/contracts/access/extensions/IAccessControlEnumerable.sol";

import { ProxyAdmin } from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import { TransparentUpgradeableProxy } from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import "forge-std/Test.sol";

import { IERC721Common } from "src/interfaces/IERC721Common.sol";
import { IERC721PresetMinterPauserAutoIdCustomized } from "src/interfaces/IERC721PresetMinterPauserAutoIdCustomized.sol";
import { IERC721State } from "src/interfaces/IERC721State.sol";
import {
  ERC721CommonUpgradeable,
  ERC721PresetMinterPauserAutoIdCustomizedUpgradeable,
  SampleERC721Upgradeable
} from "src/mock/SampleERC721Upgradeable.sol";
import { ERC721NonceUpgradeable } from "src/upgradeable/refs/ERC721NonceUpgradeable.sol";

contract SampleERC721Upgradeable_Test is Test {
  using Strings for uint256;

  event NonceUpdated(uint256 indexed tokenId, uint256 indexed nonce);

  string public constant NAME = "SampleERC721";
  string public constant SYMBOL = "NFT";
  string public constant BASE_URI = "http://example.com/";

  address internal _proxyAdmin;
  // token test
  ERC721CommonUpgradeable internal _testToken;

  function setUp() public virtual {
    _proxyAdmin = address(new ProxyAdmin(address(this)));

    bytes memory initializeData =
      abi.encodeCall(ERC721PresetMinterPauserAutoIdCustomizedUpgradeable.initialize, (NAME, SYMBOL, BASE_URI));
    TransparentUpgradeableProxy proxy =
      new TransparentUpgradeableProxy(address(new SampleERC721Upgradeable()), _proxyAdmin, initializeData);
    _testToken = SampleERC721Upgradeable(address(proxy));
  }

  function testName() public virtual {
    assertEq(_token().name(), NAME);
  }

  function testSymbol() public virtual {
    assertEq(_token().symbol(), SYMBOL);
  }

  function testFirstTokenId() public virtual {
    (uint256 tokenId,) = _mint(address(1));
    assertNotEq(tokenId, 0);
  }

  function testTokenURI(
    address from
  ) public virtual {
    vm.assume(from.code.length == 0 && from != address(0));
    (uint256 tokenId,) = _mint(from);
    assertEq(_token().tokenURI(tokenId), string(abi.encodePacked(BASE_URI, tokenId.toString())));
  }

  function testNonce(address from, address to, uint256 transferTimes) public virtual {
    vm.assume(from.code.length == 0 && to.code.length == 0 && from != address(0) && to != address(0));
    vm.assume(transferTimes > 0 && transferTimes < 10);
    (uint256 tokenId, uint256 nonce) = _mint(from);

    for (uint256 _i; _i < transferTimes; _i++) {
      vm.expectEmit(true, true, true, true, address(_token()));
      emit NonceUpdated(tokenId, ++nonce);
      _transferFrom(from, to, tokenId);

      vm.expectEmit(true, true, true, true, address(_token()));
      emit NonceUpdated(tokenId, ++nonce);
      _transferFrom(to, from, tokenId);
    }

    assertEq(nonce, _token().nonces(tokenId));
  }

  function testState(address from, address to) public virtual {
    vm.assume(from.code.length == 0 && to.code.length == 0 && from != address(0) && to != address(0));
    (uint256 tokenId,) = _mint(from);

    bytes32 _state0 = keccak256(_token().stateOf(tokenId));
    _transferFrom(from, to, tokenId);
    _transferFrom(to, from, tokenId);
    bytes32 _state1 = keccak256(_token().stateOf(tokenId));
    assertNotEq(_state0, _state1);
  }

  function testSupportInterface() public view {
    assertEq(_token().supportsInterface(type(IERC721).interfaceId), true);
    assertEq(_token().supportsInterface(type(IAccessControlEnumerable).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC721Enumerable).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC721State).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC721PresetMinterPauserAutoIdCustomized).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC721Common).interfaceId), true);
  }

  function _mint(
    address _user
  ) internal virtual returns (uint256 tokenId, uint256 nonce) {
    _token().mint(_user);
    uint256 _balance = _token().balanceOf(_user);
    return (_token().tokenOfOwnerByIndex(_user, _balance - 1), 1);
  }

  function _transferFrom(address from, address to, uint256 tokenId) internal virtual {
    vm.prank(from);
    _token().transferFrom(from, to, tokenId);
  }

  function _token() internal view virtual returns (ERC721CommonUpgradeable) {
    return _testToken;
  }
}
