# Thetan Arena — Smart Contract Sources

All verified contract source code fetched from BscScan (BSC mainnet, chainId 56).
Each subdirectory contains the contract's own `.sol` file plus all OpenZeppelin dependencies.

| Directory | Contract Name | Address | Files | Compiler |
|-----------|---------------|---------|:-----:|----------|
| `ClaimToken/` | ClaimToken | [0x458363e309a2638c08afb2621255ef53eACB1c33](https://bscscan.com/address/0x458363e309a2638c08afb2621255ef53eACB1c33) | 9 | v0.8.0+commit.c7dfd78e |
| `CosmeticItemV2/` | CosmeticItemV2 | [0x257e7cf74d68ddbe291420e109e18cbee62475f1](https://bscscan.com/address/0x257e7cf74d68ddbe291420e109e18cbee62475f1) | 19 | v0.8.2+commit.661d1103 |
| `MarketplaceV3/` | MarketplaceV3 | [0x39A4d9815AAe1131D41ED22CD2B45dE9e75447cA](https://bscscan.com/address/0x39A4d9815AAe1131D41ED22CD2B45dE9e75447cA) | 14 | v0.8.2+commit.661d1103 |
| `Marketplace_OLD/` | MarketplaceV2 | [0x7Bf5D1dec7e36d5B4e9097B48A1B9771e6c96AA4](https://bscscan.com/address/0x7Bf5D1dec7e36d5B4e9097B48A1B9771e6c96AA4) | 11 | v0.8.0+commit.c7dfd78e |
| `RentalHero/` | HeroRental | [0xBd69AbdCC8aCDAfcA69C96e10141F573842B40e4](https://bscscan.com/address/0xBd69AbdCC8aCDAfcA69C96e10141F573842B40e4) | 8 | v0.8.0+commit.c7dfd78e |
| `Staking_v/` | IngameDeposit | [0x2df3f5782e1c8f2f518e0b3f15e4f27d62a4a3b2](https://bscscan.com/address/0x2df3f5782e1c8f2f518e0b3f15e4f27d62a4a3b2) | 7 | v0.8.2+commit.661d1103 |
| `ThetanCoin/` | ThetanCoin | [0x24802247bd157d771b7effa205237d8e9269ba8a](https://bscscan.com/address/0x24802247bd157d771b7effa205237d8e9269ba8a) | 16 | v0.8.0+commit.c7dfd78e |
| `ThetanHero/` | ThetanHero | [0x98eb46cbf76b19824105dfbcfa80ea8ed020c6f4](https://bscscan.com/address/0x98eb46cbf76b19824105dfbcfa80ea8ed020c6f4) | 16 | v0.8.0+commit.c7dfd78e |
| `ThetanVault/` | ThetanVault | [0x6A1d1bFBdb28b4FAEC732368bB7039204B5DE887](https://bscscan.com/address/0x6A1d1bFBdb28b4FAEC732368bB7039204B5DE887) | 12 | v0.8.20+commit.a1b79de6 |
| `Token_T/` | ThetanNFTMinter | [0x87B0Bda917FCe2fb661db80C7BD2dec4Ee533025](https://bscscan.com/address/0x87B0Bda917FCe2fb661db80C7BD2dec4Ee533025) | 30 | v0.8.20+commit.a1b79de6 |

**Total: 142 source files, 606,632 bytes**

## Directory Structure

```
contracts/
  ClaimToken/                    # 0x458363e309a2638c08afb2621255ef53eACB1c33
    contracts__ClaimToken.sol
    # OpenZeppelin dependencies (8 files):
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__token__ERC20__IERC20.sol
    @openzeppelin__contracts__token__ERC20__utils__SafeERC20.sol
    @openzeppelin__contracts__token__ERC721__IERC721.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__cryptography__ECDSA.sol
    @openzeppelin__contracts__utils__introspection__IERC165.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  CosmeticItemV2/                    # 0x257e7cf74d68ddbe291420e109e18cbee62475f1
    contracts__CosmeticItemV2.sol
    # OpenZeppelin dependencies (18 files):
    @openzeppelin__contracts__access__AccessControl.sol
    @openzeppelin__contracts__access__AccessControlEnumerable.sol
    @openzeppelin__contracts__access__IAccessControl.sol
    @openzeppelin__contracts__access__IAccessControlEnumerable.sol
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__security__Pausable.sol
    @openzeppelin__contracts__token__ERC721__ERC721.sol
    @openzeppelin__contracts__token__ERC721__IERC721.sol
    @openzeppelin__contracts__token__ERC721__IERC721Receiver.sol
    @openzeppelin__contracts__token__ERC721__extensions__ERC721Enumerable.sol
    @openzeppelin__contracts__token__ERC721__extensions__IERC721Enumerable.sol
    @openzeppelin__contracts__token__ERC721__extensions__IERC721Metadata.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__Strings.sol
    @openzeppelin__contracts__utils__introspection__ERC165.sol
    @openzeppelin__contracts__utils__introspection__IERC165.sol
    @openzeppelin__contracts__utils__structs__EnumerableSet.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  MarketplaceV3/                    # 0x39A4d9815AAe1131D41ED22CD2B45dE9e75447cA
    contracts__MarketplaceV3.sol
    # OpenZeppelin dependencies (13 files):
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__token__ERC20__IERC20.sol
    @openzeppelin__contracts__token__ERC20__utils__SafeERC20.sol
    @openzeppelin__contracts__token__ERC721__IERC721.sol
    @openzeppelin__contracts__token__ERC721__IERC721Receiver.sol
    @openzeppelin__contracts__token__ERC721__utils__ERC721Holder.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__Strings.sol
    @openzeppelin__contracts__utils__cryptography__ECDSA.sol
    @openzeppelin__contracts__utils__introspection__IERC165.sol
    @openzeppelin__contracts__utils__math__Math.sol
    @openzeppelin__contracts__utils__math__SafeMath.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  Marketplace_OLD/                    # 0x7Bf5D1dec7e36d5B4e9097B48A1B9771e6c96AA4
    contracts__MarketplaceV2.sol
    # OpenZeppelin dependencies (10 files):
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__token__ERC20__IERC20.sol
    @openzeppelin__contracts__token__ERC20__utils__SafeERC20.sol
    @openzeppelin__contracts__token__ERC721__IERC721.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__cryptography__ECDSA.sol
    @openzeppelin__contracts__utils__introspection__IERC165.sol
    @openzeppelin__contracts__utils__math__Math.sol
    @openzeppelin__contracts__utils__math__SafeMath.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  RentalHero/                    # 0xBd69AbdCC8aCDAfcA69C96e10141F573842B40e4
    contracts__HeroRental.sol
    # OpenZeppelin dependencies (7 files):
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__token__ERC20__IERC20.sol
    @openzeppelin__contracts__token__ERC20__utils__SafeERC20.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__cryptography__ECDSA.sol
    @openzeppelin__contracts__utils__math__SafeMath.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  Staking_v/                    # 0x2df3f5782e1c8f2f518e0b3f15e4f27d62a4a3b2
    contracts__IngameDeposit.sol
    # OpenZeppelin dependencies (6 files):
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__token__ERC20__IERC20.sol
    @openzeppelin__contracts__token__ERC20__extensions__draft-IERC20Permit.sol
    @openzeppelin__contracts__token__ERC20__utils__SafeERC20.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  ThetanCoin/                    # 0x24802247bd157d771b7effa205237d8e9269ba8a
    contracts__ThetanCoin.sol
    # OpenZeppelin dependencies (15 files):
    @openzeppelin__contracts__access__AccessControl.sol
    @openzeppelin__contracts__access__AccessControlEnumerable.sol
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__security__Pausable.sol
    @openzeppelin__contracts__token__ERC20__ERC20.sol
    @openzeppelin__contracts__token__ERC20__IERC20.sol
    @openzeppelin__contracts__token__ERC20__extensions__ERC20Burnable.sol
    @openzeppelin__contracts__token__ERC20__extensions__ERC20Pausable.sol
    @openzeppelin__contracts__token__ERC20__extensions__IERC20Metadata.sol
    @openzeppelin__contracts__token__ERC20__presets__ERC20PresetMinterPauser.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__Strings.sol
    @openzeppelin__contracts__utils__introspection__ERC165.sol
    @openzeppelin__contracts__utils__introspection__IERC165.sol
    @openzeppelin__contracts__utils__structs__EnumerableSet.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  ThetanHero/                    # 0x98eb46cbf76b19824105dfbcfa80ea8ed020c6f4
    contracts__ThetanHero.sol
    # OpenZeppelin dependencies (15 files):
    @openzeppelin__contracts__access__AccessControl.sol
    @openzeppelin__contracts__access__AccessControlEnumerable.sol
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__token__ERC721__ERC721.sol
    @openzeppelin__contracts__token__ERC721__IERC721.sol
    @openzeppelin__contracts__token__ERC721__IERC721Receiver.sol
    @openzeppelin__contracts__token__ERC721__extensions__ERC721Enumerable.sol
    @openzeppelin__contracts__token__ERC721__extensions__IERC721Enumerable.sol
    @openzeppelin__contracts__token__ERC721__extensions__IERC721Metadata.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__Strings.sol
    @openzeppelin__contracts__utils__introspection__ERC165.sol
    @openzeppelin__contracts__utils__introspection__IERC165.sol
    @openzeppelin__contracts__utils__structs__EnumerableSet.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  ThetanVault/                    # 0x6A1d1bFBdb28b4FAEC732368bB7039204B5DE887
    contracts__waiting__ThetanVault.sol
    # OpenZeppelin dependencies (11 files):
    @openzeppelin__contracts__access__AccessControl.sol
    @openzeppelin__contracts__access__IAccessControl.sol
    @openzeppelin__contracts__token__ERC20__IERC20.sol
    @openzeppelin__contracts__token__ERC20__extensions__IERC20Permit.sol
    @openzeppelin__contracts__token__ERC20__utils__SafeERC20.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__Pausable.sol
    @openzeppelin__contracts__utils__ReentrancyGuard.sol
    @openzeppelin__contracts__utils__introspection__ERC165.sol
    @openzeppelin__contracts__utils__introspection__IERC165.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  Token_T/                    # 0x87B0Bda917FCe2fb661db80C7BD2dec4Ee533025
    contracts__waiting__ThetanNFT.sol
    contracts__waiting__ThetanNFTMinter.sol
    contracts__waiting__ThetanTransfer.sol
    contracts__waiting__ThetanVault.sol
    # OpenZeppelin dependencies (26 files):
    @openzeppelin__contracts__access__AccessControl.sol
    @openzeppelin__contracts__access__IAccessControl.sol
    @openzeppelin__contracts__access__Ownable.sol
    @openzeppelin__contracts__interfaces__draft-IERC6093.sol
    @openzeppelin__contracts__token__ERC20__IERC20.sol
    @openzeppelin__contracts__token__ERC20__extensions__IERC20Permit.sol
    @openzeppelin__contracts__token__ERC20__utils__SafeERC20.sol
    @openzeppelin__contracts__token__ERC721__ERC721.sol
    @openzeppelin__contracts__token__ERC721__IERC721.sol
    @openzeppelin__contracts__token__ERC721__IERC721Receiver.sol
    @openzeppelin__contracts__token__ERC721__extensions__ERC721Burnable.sol
    @openzeppelin__contracts__token__ERC721__extensions__ERC721Enumerable.sol
    @openzeppelin__contracts__token__ERC721__extensions__ERC721Pausable.sol
    @openzeppelin__contracts__token__ERC721__extensions__IERC721Enumerable.sol
    @openzeppelin__contracts__token__ERC721__extensions__IERC721Metadata.sol
    @openzeppelin__contracts__utils__Address.sol
    @openzeppelin__contracts__utils__Context.sol
    @openzeppelin__contracts__utils__Pausable.sol
    @openzeppelin__contracts__utils__ReentrancyGuard.sol
    @openzeppelin__contracts__utils__Strings.sol
    @openzeppelin__contracts__utils__cryptography__ECDSA.sol
    @openzeppelin__contracts__utils__cryptography__MessageHashUtils.sol
    @openzeppelin__contracts__utils__introspection__ERC165.sol
    @openzeppelin__contracts__utils__introspection__IERC165.sol
    @openzeppelin__contracts__utils__math__Math.sol
    @openzeppelin__contracts__utils__math__SignedMath.sol
    _combined.sol            # All files concatenated
    _metadata.json           # BscScan metadata
    _raw_etherscan_response.sol  # Original API response
  INDEX.md                   # This file
```

## Notes

- `Marketplace_OLD` = MarketplaceV2 (predecessor to MarketplaceV3)
- `Token_T` = ThetanNFTMinter (contains ThetanNFT, ThetanTransfer, ThetanVault as bundled sources)
- `Staking_v` = IngameDeposit (one-way deposit, no on-chain withdrawal)
- `RentalHero` = HeroRental (NFT rental market)
- All contracts verified on BscScan with full source code
