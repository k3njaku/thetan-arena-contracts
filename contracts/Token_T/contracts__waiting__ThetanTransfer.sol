// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: ThetanNFTMinter
// Verified name: Token_T
// Address: 
// Compiler: v0.8.20+commit.a1b79de6
// Source file: contracts/waiting/ThetanTransfer.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import "./ThetanVault.sol";

contract ThetanTransfer {
    using SafeERC20 for IERC20;

    struct PriceInfo {
        uint256 netValue; // net value
        address erc20;
        bool isVault;
        uint256 platformFee;
        uint256 []fees;
        address []recipients;
    }

    address public feeToAddress;
    ThetanVault public vault;

    constructor(address _feeToAddress, address _vault) {
        feeToAddress = _feeToAddress;
        vault = ThetanVault(_vault);
    }

    function transferCurrency(address from, address to, PriceInfo calldata price) internal {
        if (price.isVault) {
            transferVault(from, to, price);
            return;
        } 

        transferERC20(from, to, price);
    }

    function transferVault(address from, address to, PriceInfo calldata price) internal {
        // Initialize the BatchTransfer struct
        ThetanVault.BatchTransfer memory batch;
        batch.to = new address[](price.fees.length + 2); // +2 for the platform fee and the final transfer to the seller
        batch.amount = new uint256[](price.fees.length + 2);

        batch.to[0] = feeToAddress;
        batch.amount[0] = price.platformFee;

        batch.to[1] = to;
        batch.amount[1] = price.netValue;

        // Add individual fees to the batch
        for (uint256 i = 0; i < price.fees.length; i++) {
            batch.to[i + 2] = price.recipients[i];
            batch.amount[i + 2] = price.fees[i];
        }

        vault.transferBatchFrom(from, price.erc20, batch);
    }

    function transferERC20(address from, address to, PriceInfo calldata price) internal {
        if (price.platformFee > 0) {
            IERC20(price.erc20).safeTransferFrom(from, feeToAddress, price.platformFee);
        }

        if (price.netValue > 0) {
            IERC20(price.erc20).safeTransferFrom(from, to, price.netValue);
        }

        for (uint256 i = 0; i < price.fees.length; i++) {
            if (price.fees[i] == 0) {
                continue;
            }

            IERC20(price.erc20).safeTransferFrom(from, price.recipients[i], price.fees[i]);
        }
    }

    function encodePrice(PriceInfo memory price) internal pure returns (bytes memory encoded) {
        encoded = abi.encodePacked(price.netValue, price.erc20, price.platformFee, price.isVault, price.fees, price.recipients);
    }
}