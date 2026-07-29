// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: MarketplaceV2
// Verified name: Marketplace_OLD
// Address: 
// Compiler: v0.8.0+commit.c7dfd78e
// Source file: contracts/MarketplaceV2.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MarketplaceV2 is Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    // Supported payment token WETH & list of authorized ERC20
    mapping(address => bool) public paymentTokens;
    mapping(bytes => bool) public usedSignatures;

    // Address to receive transaction fee
    address public feeToAddress;
    uint256 public transactionFee;

    // Events
    event MatchTransaction(
        uint256 indexed tokenId,
        address contractAddress,
        uint256 price,
        address paymentToken,
        address seller,
        address buyer,
        uint256 fee
    );

    function setFeeToAddress(address _feeToAddress) public onlyOwner {
        feeToAddress = _feeToAddress;
    }

    function setTransactionFee(uint256 _transactionFee) public onlyOwner {
        transactionFee = _transactionFee;
    }

    function setPaymentTokens(address[] calldata _paymentTokens)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < _paymentTokens.length; i++) {
            if (paymentTokens[_paymentTokens[i]] == true) {
                continue;
            }

            paymentTokens[_paymentTokens[i]] = true;
        }
    }

    function removePaymentTokens(address[] calldata _removedPaymentTokens)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < _removedPaymentTokens.length; i++) {
            paymentTokens[_removedPaymentTokens[i]] = false;
        }
    }

    function ignoreSignature(
        address[2] calldata addresses,
        uint256[3] calldata values,
        bytes calldata signature
    ) external {
        bytes32 criteriaMessageHash = getMessageHash(
            addresses[0],
            values[0],
            addresses[1],
            values[1],
            values[2]
        );

        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(
            criteriaMessageHash
        );

        require(
            ECDSA.recover(ethSignedMessageHash, signature) == _msgSender(),
            "Marketplace: invalid seller signature"
        );

        usedSignatures[signature] = true;
    }

    /**
     * @dev Function matched transaction with user signatures
     */
    function matchTransaction(
        address[3] calldata addresses,
        uint256[3] calldata values,
        bytes calldata signature
    ) external returns (bool) {
        require(
            paymentTokens[addresses[2]] == true,
            "Marketplace: invalid payment method"
        );

        require(
            !usedSignatures[signature],
            "Marketplace: signature used. please send another transaction with new signature"
        );

        bytes32 criteriaMessageHash = getMessageHash(
            addresses[1],
            values[0],
            addresses[2],
            values[1],
            values[2]
        );

        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(
            criteriaMessageHash
        );

        require(
            ECDSA.recover(ethSignedMessageHash, signature) == addresses[0],
            "Marketplace: invalid seller signature"
        );

        // check current ownership
        IERC721 nft = IERC721(addresses[1]);
        require(
            nft.ownerOf(values[0]) == addresses[0],
            "Marketplace: seller is not owner of this item now"
        );

        // Check payment approval and buyer balance
        IERC20 paymentContract = IERC20(addresses[2]);
        require(
            paymentContract.balanceOf(_msgSender()) >= values[1],
            "Marketplace: buyer doesn't have enough token to buy this item"
        );
        require(
            paymentContract.allowance(_msgSender(), address(this)) >= values[1],
            "Marketplace: buyer doesn't approve marketplace to spend payment amount"
        );

        // We divide by 10000 to support decimal value such as 4.25% => 425 / 10000
        uint256 fee = transactionFee.mul(values[1]).div(10000);
        uint256 payToSellerAmount = values[1].sub(fee);

        // transfer money to seller
        paymentContract.safeTransferFrom(
            _msgSender(),
            addresses[0],
            payToSellerAmount
        );

        // transfer fee to address
        if (fee > 0) {
            paymentContract.safeTransferFrom(_msgSender(), feeToAddress, fee);
        }

        // transfer item to buyer
        nft.safeTransferFrom(addresses[0], _msgSender(), values[0]);

        usedSignatures[signature] = true;
        // emit sale event
        emitEvent(addresses, values);
        return true;
    }

    /**
     * @dev Function to emit transaction matched event
     */
    function emitEvent(
        address[3] calldata addresses,
        uint256[3] calldata values
    ) internal {
        emit MatchTransaction(
            values[0],
            addresses[1],
            values[1],
            addresses[2],
            addresses[0],
            _msgSender(),
            transactionFee
        );
    }

    function getMessageHash(
        address _nftAddress,
        uint256 _tokenId,
        address _paymentErc20,
        uint256 _price,
        uint256 _saltNonce
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    _nftAddress,
                    _tokenId,
                    _paymentErc20,
                    _price,
                    _saltNonce
                )
            );
    }
}
