// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: ThetanNFTMinter
// Verified name: Token_T
// Address: 
// Compiler: v0.8.20+commit.a1b79de6
// Source file: contracts/waiting/ThetanNFTMinter.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ThetanTransfer.sol";
import "./ThetanNFT.sol";

contract ThetanNFTMinter is Ownable, ThetanTransfer {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    mapping(uint256 => bool) public idExecuted; 
    address public signer; 
    address public nft; 

    event Mint(uint256 id, address to, uint256 tokenId);
    event MintBatch(uint256 id, address[] to, uint256[] tokenIds);
    event MintBatchTo(uint256 id, address to, uint256[] tokenIds);

    // @dev: _nft address may be ignored
    constructor(address _nft, address _signer, address _feer, address _vault) Ownable(msg.sender) ThetanTransfer(_feer, _vault) {
        require(_signer != address(0), "ThetanNFTMinter: Invalid signer address");
        require(_feer != address(0), "ThetanNFTMinter: Invalid fee address");

        signer = _signer;
        nft = _nft;
        feeToAddress = _feer;
        vault = ThetanVault(_vault);
    }

    function setFeer(address _feer) public onlyOwner {
        feeToAddress = _feer;
    }

    function setSigner(address _signer) public onlyOwner {
        signer = _signer;
    }

    function setNFT(address _nft) public onlyOwner {
        nft = _nft;
    }

    function setVault(address _vault) public onlyOwner {
        vault = ThetanVault(_vault);
    }

    function mint(uint256 id, address to, uint256 tokenId, uint64 expiredAt, bytes calldata signature) public {
        checkRequest(id, expiredAt);
        idExecuted[id] = true;

        require(verifySignature(keccak256(abi.encodePacked(id, to, tokenId, expiredAt)), signature), "ThetanNFTMinter: Invalid signature");

        ThetanNFT(nft).safeMint(to, tokenId);
        emit Mint(id, to, tokenId);
    }

    function mintBatchTo(uint256 id, address to, uint256[] calldata tokenIds, uint64 expiredAt, bytes calldata signature) public {
        checkRequest(id, expiredAt);
        idExecuted[id] = true;

        require(verifySignature(keccak256(abi.encodePacked(id, to, tokenIds, expiredAt)), signature), "ThetanNFTMinter: Invalid signature");

        ThetanNFT(nft).safeMintBatchTo(to, tokenIds);
        emit MintBatchTo(id, to, tokenIds);
    }

    function mintBatch(uint256 id, address[] calldata tos, uint256[] calldata tokenIds, uint64 expiredAt, bytes calldata signature) public {
        checkRequest(id, expiredAt);
        idExecuted[id] = true;

        require(verifySignature(keccak256(abi.encodePacked(id, tos, tokenIds, expiredAt)), signature), "ThetanNFTMinter: Invalid signature");

        ThetanNFT(nft).safeMintBatch(tos, tokenIds);
        emit MintBatch(id, tos, tokenIds);
    }

    function mintWithFee(uint256 id, address to, uint256 tokenId, PriceInfo calldata price, uint64 expiredAt, bytes calldata signature) public {
        checkRequest(id, expiredAt);
        idExecuted[id] = true;

        require(verifySignature(keccak256(abi.encodePacked( 
            id, to, tokenId, encodePrice(price), expiredAt)), signature), "ThetanNFTMinter: Invalid signature");

        transferCurrency(msg.sender, feeToAddress, price);

        ThetanNFT(nft).safeMint(to, tokenId);
        emit Mint(id, to, tokenId);
    }

    function mintBatchToWithFee(uint256 id, address to, uint256[] calldata tokenIds, PriceInfo calldata price, uint64 expiredAt, bytes calldata signature) public {
        checkRequest(id, expiredAt);
        idExecuted[id] = true;

        require(verifySignature(keccak256(abi.encodePacked( 
            id, to, tokenIds, encodePrice(price), expiredAt)), signature), "ThetanNFTMinter: Invalid signature");

        transferCurrency(msg.sender, feeToAddress, price);

        ThetanNFT(nft).safeMintBatchTo(to, tokenIds);
        emit MintBatchTo(id, to, tokenIds);
    }

    function mintBatchWithFee(uint256 id, address[] calldata tos, uint256[] calldata tokenIds, PriceInfo calldata price, uint64 expiredAt, bytes calldata signature) public {
        checkRequest(id, expiredAt);
        idExecuted[id] = true;

        require(verifySignature(keccak256(abi.encodePacked( 
            id, tos, tokenIds, encodePrice(price), expiredAt)), signature), "ThetanNFTMinter: Invalid signature");

        transferCurrency(msg.sender, feeToAddress, price);

        ThetanNFT(nft).safeMintBatch(tos, tokenIds);
        emit MintBatch(id, tos, tokenIds);
    }

    function verifySignature(bytes32 messageHash, bytes calldata signature) public view returns (bool) {
        return messageHash.toEthSignedMessageHash().recover(signature) == signer;
    }

    function checkRequest(uint256 id, uint64 expiredAt) internal view {
        require(!idExecuted[id], "ThetanNFTMinter: Id already executed");
        require(block.timestamp <= expiredAt, "ThetanNFTMinter: Transaction expired");
    }
}