// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { ERC721Nonce } from "../../src/refs/ERC721Nonce.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { SampleERC721, ERC721Common } from "../../src/mock/SampleERC721.sol";
import { IERC721Common } from "src/interfaces/IERC721Common.sol";
import { IERC721PresetMinterPauserAutoIdCustomized } from "src/interfaces/IERC721PresetMinterPauserAutoIdCustomized.sol";
import { IERC721State } from "src/interfaces/IERC721State.sol";

contract SampleERC721Test is Test {
  using Strings for uint256;

  event NonceUpdated(uint256 indexed _tokenId, uint256 indexed _nonce);

  string public constant NAME = "SampleERC721";
  string public constant SYMBOL = "NFT";
  string public constant BASE_URI = "http://example.com/";

  ERC721Common internal _t;

  function setUp() public virtual {
    _t = new SampleERC721(NAME, SYMBOL, BASE_URI);
  }

  function testName() public virtual {
    assertEq(_token().name(), NAME);
  }

  function testSymbol() public virtual {
    assertEq(_token().symbol(), SYMBOL);
  }

  function testFirstTokenId() public virtual {
    (uint256 _tokenId,) = _mint(address(1));
    assertNotEq(_tokenId, 0);
  }

  function testTokenURI(address _from) public virtual {
    vm.assume(_from.code.length == 0 && _from != address(0));
    (uint256 _tokenId,) = _mint(_from);
    assertEq(_token().tokenURI(_tokenId), string(abi.encodePacked(BASE_URI, _tokenId.toString())));
  }

  function testNonce(address _from, address _to, uint256 _transferTimes) public virtual {
    vm.assume(_from.code.length == 0 && _to.code.length == 0 && _from != address(0) && _to != address(0));
    vm.assume(_transferTimes > 0 && _transferTimes < 10);
    (uint256 _tokenId, uint256 _nonce) = _mint(_from);

    for (uint256 _i; _i < _transferTimes; _i++) {
      vm.expectEmit(true, true, true, true, address(_token()));
      emit NonceUpdated(_tokenId, ++_nonce);
      _transferFrom(_from, _to, _tokenId);

      vm.expectEmit(true, true, true, true, address(_token()));
      emit NonceUpdated(_tokenId, ++_nonce);
      _transferFrom(_to, _from, _tokenId);
    }

    assertEq(_nonce, _token().nonces(_tokenId));
  }

  function testState(address _from, address _to) public virtual {
    vm.assume(_from.code.length == 0 && _to.code.length == 0 && _from != address(0) && _to != address(0));
    (uint256 _tokenId,) = _mint(_from);

    bytes32 _state0 = keccak256(_token().stateOf(_tokenId));
    _transferFrom(_from, _to, _tokenId);
    _transferFrom(_to, _from, _tokenId);
    bytes32 _state1 = keccak256(_token().stateOf(_tokenId));
    assertNotEq(_state0, _state1);
  }

  function testSupportInterface() public {
    assertEq(_token().supportsInterface(type(IERC721State).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC721PresetMinterPauserAutoIdCustomized).interfaceId), true);
    assertEq(_token().supportsInterface(type(IERC721Common).interfaceId), true);
  }

  function _mint(address _user) internal virtual returns (uint256 _tokenId, uint256 _nonce) {
    _token().mint(_user);
    uint256 _balance = _token().balanceOf(_user);
    return (_token().tokenOfOwnerByIndex(_user, _balance - 1), 1);
  }

  function _transferFrom(address _from, address _to, uint256 _tokenId) internal virtual {
    vm.prank(_from);
    _token().transferFrom(_from, _to, _tokenId);
  }

  function _token() internal view virtual returns (ERC721Common) {
    return _t;
  }
}
