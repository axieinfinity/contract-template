// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol)

pragma solidity ^0.8.0;

import "../../lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/extensions/ERC721PausableUpgradeable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlEnumerableUpgradeable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/utils/ContextUpgradeable.sol";
import "../../lib/openzeppelin-contracts-upgradeable/contracts/utils/CountersUpgradeable.sol";
import {Initializable} from "../../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";

/**
 * @dev {ERC721} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a minter role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *  - token ID and URI autogeneration
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * The account that deploys the contract will be granted the minter and pauser
 * roles, as well as the default admin role, which will let it grant both minter
 * and pauser roles to other accounts.
 *
 * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
 */
contract ERC721PresetMinterPauserAutoIdCustomizedUpgradeable is
  Initializable,
  ContextUpgradeable,
  AccessControlEnumerableUpgradeable,
  ERC721EnumerableUpgradeable,
  ERC721BurnableUpgradeable,
  ERC721PausableUpgradeable
{
  error ErrUnauthorizedAccount(address account, bytes32 neededRole);

  using CountersUpgradeable for CountersUpgradeable.Counter;

  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  CountersUpgradeable.Counter private _tokenIdTracker;

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
  function __ERC721PresetMinterPauserAutoId_init(string memory name, string memory symbol, string memory baseTokenURI)
    internal
    onlyInitializing
  {
    __ERC721_init_unchained(name, symbol);
    __Pausable_init_unchained();
    __ERC721PresetMinterPauserAutoId_init_unchained(name, symbol, baseTokenURI);
  }

  function __ERC721PresetMinterPauserAutoId_init_unchained(string memory, string memory, string memory baseTokenURI)
    internal
    onlyInitializing
  {
    _baseTokenURI = baseTokenURI;

    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

    _setupRole(MINTER_ROLE, _msgSender());
    _setupRole(PAUSER_ROLE, _msgSender());

    _tokenIdTracker.increment();
  }

  /**
   * @dev Creates a new token for `to`. Its token ID will be automatically
   * assigned (and available on the emitted {IERC721Upgradeable-Transfer} event), and the token
   * URI autogenerated based on the base URI passed at construction.
   *
   * See {ERC721Upgradeable-_mint}.
   *
   * Requirements:
   *
   * - the caller must have the `MINTER_ROLE`.
   */
  function mint(address to) public virtual returns (uint256 tokenId) {
    address sender = _msgSender();
    if (!hasRole(MINTER_ROLE, sender)) revert ErrUnauthorizedAccount(sender, MINTER_ROLE);

    tokenId = _mintFor(to);
  }

  /**
   * @dev Pauses all token transfers.
   *
   * See {ERC721PausableUpgradeable} and {PausableUpgradeable-_pause}.
   *
   * Requirements:
   *
   * - the caller must have the `PAUSER_ROLE`.
   */
  function pause() public virtual {
    address sender = _msgSender();
    if (!hasRole(PAUSER_ROLE, sender)) revert ErrUnauthorizedAccount(sender, PAUSER_ROLE);

    _pause();
  }

  /**
   * @dev Unpauses all token transfers.
   *
   * See {ERC721PausableUpgradeable} and {PausableUpgradeable-_unpause}.
   *
   * Requirements:
   *
   * - the caller must have the `PAUSER_ROLE`.
   */
  function unpause() public virtual {
    address sender = _msgSender();
    if (!hasRole(PAUSER_ROLE, sender)) revert ErrUnauthorizedAccount(sender, PAUSER_ROLE);

    _unpause();
  }

  /**
   * @dev See {IERC165-supportsInterface}.
   */
  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(AccessControlEnumerableUpgradeable, ERC721Upgradeable, ERC721EnumerableUpgradeable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }

  function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)
    internal
    virtual
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721PausableUpgradeable)
  {
    super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
  }

  /**
   * @dev Helper function to mint for address `to`.
   *
   * See {ERC721Upgradeable-_mint}.
   *
   */
  function _mintFor(address to) internal virtual returns (uint256 _tokenId) {
    // We cannot just use balanceOf to create the new tokenId because tokens
    // can be burned (destroyed), so we need a separate counter.
    _tokenId = _tokenIdTracker.current();
    _mint(to, _tokenId);
    _tokenIdTracker.increment();
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
}
