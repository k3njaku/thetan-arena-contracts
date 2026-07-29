// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: ThetanCoin
// Verified name: ThetanCoin
// Address: 
// Compiler: v0.8.0+commit.c7dfd78e
// Source file: contracts/ThetanCoin.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract ThetanCoin is ERC20PresetMinterPauser, Ownable {
    uint256 public initializedCap = 20000000 * 1e18;

    constructor() ERC20PresetMinterPauser("Thetan Coin", "THC") {
        _mint(_msgSender(), initializedCap);
    }
}
