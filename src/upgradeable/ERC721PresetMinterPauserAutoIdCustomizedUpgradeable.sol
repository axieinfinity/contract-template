// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { IERC721PresetMinterPauserAutoIdCustomized } from "../interfaces/IERC721PresetMinterPauserAutoIdCustomized.sol";
import { AccessControlEnumerableUpgradeable } from
  "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { ERC721Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import { ERC721BurnableUpgradeable } from
  "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import { ERC721EnumerableUpgradeable } from
  "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import { ERC721PausableUpgradeable } from
  "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721PausableUpgradeable.sol";
import { ContextUpgradeable } from "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

/**
 * @dev ERC721PresetMinterPauserAutoIdCustomizedUpgradeable is a customized version of
 * openzeppelin-contracts-upgradeable/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoIdUpgradeable.sol to
 * change the private counter and
 * base token URI into internal, mainly to support the inherited contracts.
 */
contract ERC721PresetMinterPauserAutoIdCustomizedUpgradeable is
  Initializable,
  ContextUpgradeable,
  AccessControlEnumerableUpgradeable,
  ERC721EnumerableUpgradeable,
  ERC721BurnableUpgradeable,
  ERC721PausableUpgradeable,
  IERC721PresetMinterPauserAutoIdCustomized
{
  error ErrUnauthorizedAccount(address account, bytes32 neededRole);

  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  uint256 private _tokenIdTracker;

  string private _baseTokenURI;

  /**
   * @dev This empty reserved space is put in place to allow future versions to add new
   * variables without shifting down storage in the inheritance chain.
   */
  uint256[50] private __gap;

  function initialize(string memory name, string memory symbol, string memory baseTokenURI) public virtual initializer {
    __ERC721PresetMinterPauserAutoId_init(name, symbol, baseTokenURI);
  }

  /**
   * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
   * account that deploys the contract.
   *
   * Token URIs will be autogenerated based on `baseURI` and their token IDs.
   * See {ERC721-tokenURI}.
   */
  function __ERC721PresetMinterPauserAutoId_init(
    string memory name,
    string memory symbol,
    string memory baseTokenURI
  ) internal onlyInitializing {
    __ERC721_init_unchained(name, symbol);
    __Pausable_init_unchained();
    __ERC721PresetMinterPauserAutoId_init_unchained(name, symbol, baseTokenURI);
  }

  function __ERC721PresetMinterPauserAutoId_init_unchained(
    string memory,
    string memory,
    string memory baseTokenURI
  ) internal onlyInitializing {
    _baseTokenURI = baseTokenURI;

    _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());

    _grantRole(MINTER_ROLE, _msgSender());
    _grantRole(PAUSER_ROLE, _msgSender());

    ++_tokenIdTracker;
  }

  /// @inheritdoc IERC721PresetMinterPauserAutoIdCustomized
  function mint(
    address to
  ) public virtual returns (uint256 tokenId) {
    address sender = _msgSender();
    if (!hasRole(MINTER_ROLE, sender)) revert ErrUnauthorizedAccount(sender, MINTER_ROLE);

    tokenId = _mintFor(to);
  }

  /// @inheritdoc IERC721PresetMinterPauserAutoIdCustomized
  function pause() public virtual {
    address sender = _msgSender();
    if (!hasRole(PAUSER_ROLE, sender)) revert ErrUnauthorizedAccount(sender, PAUSER_ROLE);

    _pause();
  }

  /// @inheritdoc IERC721PresetMinterPauserAutoIdCustomized
  function unpause() public virtual {
    address sender = _msgSender();
    if (!hasRole(PAUSER_ROLE, sender)) revert ErrUnauthorizedAccount(sender, PAUSER_ROLE);

    _unpause();
  }

  /**
   * @dev See {IERC165-supportsInterface}.
   */
  function supportsInterface(
    bytes4 interfaceId
  )
    public
    view
    virtual
    override(AccessControlEnumerableUpgradeable, ERC721Upgradeable, ERC721EnumerableUpgradeable)
    returns (bool)
  {
    return
      interfaceId == type(IERC721PresetMinterPauserAutoIdCustomized).interfaceId || super.supportsInterface(interfaceId);
  }

  /**
   * @dev Helper function to mint for address `to`.
   *
   * See {ERC721Upgradeable-_mint}.
   *
   */
  function _mintFor(
    address to
  ) internal virtual returns (uint256 tokenId) {
    // We cannot just use balanceOf to create the new tokenId because tokens
    // can be burned (destroyed), so we need a separate counter.
    tokenId = _tokenIdTracker;
    _mint(to, tokenId);
    ++_tokenIdTracker;
  }

  /**
   * @dev Helper function to mint for address `to`.
   *
   * See {ERC721Upgradeable-_mint}.
   *
   */
  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  /**
   * @dev See {ERC721Upgradeable-_update}.
   */
  function _update(
    address to,
    uint256 tokenId,
    address auth
  )
    internal
    virtual
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721PausableUpgradeable)
    returns (address from)
  {
    return super._update(to, tokenId, auth);
  }

  /**
   * @dev See {ERC721Upgradeable-_increaseBalance}.
   */
  function _increaseBalance(
    address account,
    uint128 amount
  ) internal virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
    super._increaseBalance(account, amount);
  }
}
