// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: ThetanNFTMinter
// Verified name: Token_T
// Address: 
// Compiler: v0.8.20+commit.a1b79de6
// Source file: contracts/waiting/ThetanNFT.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";

/// @custom:security-contact hoang@wolffungame.com
contract ThetanNFT is ERC721, AccessControl, ERC721Enumerable, ERC721Burnable, ERC721Pausable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(
        string memory name,
        string memory symbol,
        address defaultAdmin,
        address pauser,
        address minter
    ) ERC721(name, symbol) ERC721Pausable()  {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(PAUSER_ROLE, pauser);
        _grantRole(MINTER_ROLE, minter);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to, uint256 tokenId) public onlyRole(MINTER_ROLE) {
        require(_ownerOf(tokenId) == address(0), "ThetanNFT: tokenId must be empty");
        _safeMint(to, tokenId);
    }

    function safeMintBatch(address[] calldata to, uint256[] calldata tokenIds) public onlyRole(MINTER_ROLE) {
        require(to.length == tokenIds.length, "ThetanNFT: to and tokenIds length mismatch");

        for (uint256 i = 0; i < tokenIds.length; i++) {
            safeMint(to[i], tokenIds[i]);
        }
    }

    function safeMintBatchTo(address to, uint256[] calldata tokenIds) public onlyRole(MINTER_ROLE) {
        require(tokenIds.length == tokenIds.length, "ThetanNFT: tokenIds and tokenTypes length mismatch");

        for (uint256 i = 0; i < tokenIds.length; i++) {
            safeMint(to, tokenIds[i]);
        }
    }

    // Overrides required by Solidity
    function _increaseBalance(address account, uint128 value) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function _update(address to, uint256 tokenId, address auth) internal override(ERC721, ERC721Enumerable, ERC721Pausable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
