// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: CosmeticItemV2
// Verified name: CosmeticItemV2
// Address: 
// Compiler: v0.8.2+commit.661d1103
// Source file: contracts/CosmeticItemV2.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/// @custom:security-contact hoang@wolffungame.com
contract CosmeticItemV2 is
  ERC721,
  ERC721Enumerable,
  Pausable,
  AccessControlEnumerable
{
  /* ----- Custom types ----- */
  struct Token {
    address owner;
    uint256 id;
  }

  mapping(address => bool) public whitelist;
  mapping(address => bool) public blacklist;
  mapping(uint256 => bool) public lockedTokens;

  string private _baseTokenURI;
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  constructor() ERC721("Cosmetic Item", "CMI") {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(MINTER_ROLE, msg.sender);
    _grantRole(PAUSER_ROLE, msg.sender);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  /* ----- setup ----- */
  function updateBaseURI(string calldata baseTokenURI)
    public
    onlyRole(DEFAULT_ADMIN_ROLE)
  {
    _baseTokenURI = baseTokenURI;
  }

  /**
   * @dev Creates a new token for `to`.
   */
  function mint(address to, uint256 tokenId)
    public
    whenNotPaused
    onlyRole(MINTER_ROLE)
  {
    _safeMint(to, tokenId);
  }

  /**
   * @dev See {IERC721-isApprovedForAll}.
   */
  function isApprovedForAll(address owner, address operator)
    public
    view
    override(ERC721)
    returns (bool)
  {
    if (whitelist[operator] == true) {
      return true;
    }

    return super.isApprovedForAll(owner, operator);
  }

  /* ----- Pauser ----- */
  function pause() public onlyRole(PAUSER_ROLE) {
    _pause();
  }

  function unpause() public onlyRole(PAUSER_ROLE) {
    _unpause();
  }

  /* ----- Black/white list ----- */
  function addWhitelist(address proxy) public onlyRole(DEFAULT_ADMIN_ROLE) {
    require(whitelist[proxy] == false, "Cosmetic: already on whitelist");

    whitelist[proxy] = true;
  }

  function removeWhitelist(address proxy) public onlyRole(DEFAULT_ADMIN_ROLE) {
    require(whitelist[proxy], "Cosmetic: not on whitelist");

    whitelist[proxy] = false;
  }

  function addBlacklist(address proxy) public onlyRole(DEFAULT_ADMIN_ROLE) {
    require(blacklist[proxy] == false, "Cosmetic: already on blacklist");

    blacklist[proxy] = true;
  }

  function removeBlacklist(address proxy) public onlyRole(DEFAULT_ADMIN_ROLE) {
    require(blacklist[proxy], "Cosmetic: not on blacklist");

    blacklist[proxy] = false;
  }

  /* ----- Minter role (required: adminRole) ----- */
  function setMintFactory(address factory) public {
    grantRole(MINTER_ROLE, factory);
  }

  function removeMintFactory(address factory) public {
    revokeRole(MINTER_ROLE, factory);
  }

  /* ----- Migrate ----- */
  function migrate(Token[] calldata tokens) external onlyRole(DEFAULT_ADMIN_ROLE) {
    for (uint256 i = 0; i < tokens.length; i++) {
      _mint(tokens[i].owner, tokens[i].id);
    }
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual override(ERC721, ERC721Enumerable) whenNotPaused {
    require(!blacklist[_msgSender()], "Cosmetic: you are in blacklist");
    require(lockedTokens[tokenId] == false, "Cosmetic: token is being locked");

    super._beforeTokenTransfer(from, to, tokenId);
  }

  /* ----- interface{} ----- */
  /**
   * @dev See {IERC165-supportsInterface}.
   */
  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(AccessControlEnumerable, ERC721, ERC721Enumerable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
