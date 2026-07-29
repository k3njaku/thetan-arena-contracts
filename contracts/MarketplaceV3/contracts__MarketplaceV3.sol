// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: MarketplaceV3
// Verified name: MarketplaceV3
// Address: 
// Compiler: v0.8.2+commit.661d1103
// Source file: contracts/MarketplaceV3.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/// @custom:security-contact hoang@wolffungame.com
contract MarketplaceV3 is Ownable, ERC721Holder {
  /* ========== LIBs ========== */

  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  /* ========== STATE VARIABLES ========== */

  struct NftSold {
    bool isExist;
    address owner;
    uint256 price;
    uint256 tokenId;
    address paymentToken;
    address nftAddress;
  }
  // Supported payment token WETH & list of authorized ERC20
  mapping(address => bool) public paymentTokens;
  mapping(uint256 => NftSold) public sellingBId;
  mapping(uint256 => bool) public ids;

  // Address to receive transaction fee
  address public feeToAddress;
  uint256 public transactionFee;
  address public signer;

  /* ========== EVENTS ========== */

  event SuccessfullyBuy(
    uint256 indexed tokenId,
    address contractAddress,
    uint256 price,
    address paymentToken,
    address seller,
    address buyer,
    uint256 fee
  );
  event SuccessfulSelling(
    uint256 indexed tokenId,
    uint256 id,
    address contractAddress,
    uint256 price,
    address paymentToken,
    address seller
  );
  event CancelSelling(uint256 tokenId, address nftAddress);

  /* ========== CONFIGURATION FUNCTIONS ========== */

  function setSigner(address _signer) external onlyOwner {
    require(_signer != address(0), "invalid signer address");
    signer = _signer;
  }

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

  /* ========== WRITE FUNCTIONS ========== */

  /**
   * @dev Function to sell a nft
   */
  function selling(
    uint256 _id,
    address _nftAddress,
    address _paymentTokenAddress,
    uint256 _tokenId,
    uint256 _price,
    uint256 _expiredAt,
    bytes calldata _signature
  ) public {
    require(block.timestamp < _expiredAt, "signature expired");
    require(!sellingBId[_id].isExist, "the token is selling");
    require(paymentTokens[_paymentTokenAddress], "invalid payment method");

    verifySellingSignature(
      _id,
      _nftAddress,
      _paymentTokenAddress,
      _tokenId,
      _price,
      _expiredAt,
      _signature
    );

    IERC721 nft = IERC721(_nftAddress);
    require(nft.ownerOf(_tokenId) == _msgSender(), "not token's owner");
    // require(!nft.lockedTokens(_tokenId), "token was locked");

    sellingBId[_id] = NftSold({
      isExist: true,
      owner: _msgSender(),
      paymentToken: _paymentTokenAddress,
      price: _price,
      nftAddress: _nftAddress,
      tokenId: _tokenId
    });
    ids[_id] = true;

    // transfer nft to mkp
    nft.safeTransferFrom(msg.sender, address(this), _tokenId);

    emit SuccessfulSelling(
      _tokenId,
      _id,
      _nftAddress,
      _price,
      _paymentTokenAddress,
      _msgSender()
    );
  }

  /**
   * @dev Function to cancel a nft
   */
  function cancelSelling(uint256 _id) public {
    require(sellingBId[_id].isExist, "the token is sold or already bought");
    // check current ownership
    NftSold memory nftSold = sellingBId[_id];
    require(nftSold.owner == msg.sender, "invalid owner");
    IERC721 nft = IERC721(nftSold.nftAddress);

    //transfer to owner
    nft.safeTransferFrom(address(this), msg.sender, nftSold.tokenId);
    delete sellingBId[_id];

    emit CancelSelling(nftSold.tokenId, nftSold.nftAddress);
  }

  /**
   * @dev Function to cancel a nft
   */
  function cancelSellingByAdmin(uint256 _id) public onlyOwner {
    require(sellingBId[_id].isExist, "the token is sold or already bought");

    NftSold memory nftSold = sellingBId[_id];
    IERC721 nft = IERC721(nftSold.nftAddress);

    //transfer to owner
    nft.safeTransferFrom(address(this), msg.sender, nftSold.tokenId);

    delete sellingBId[_id];

    emit CancelSelling(nftSold.tokenId, nftSold.nftAddress);
  }

  /**
   * @dev Function to buy a nft
   */
  function buy(
    uint256 _id,
    uint256 _price,
    address _paymentToken
  ) external returns (bool) {
    require(sellingBId[_id].isExist, "the token is not sold");
    NftSold memory nftSold = sellingBId[_id];
    require(nftSold.price == _price, "wrong price");
    require(_paymentToken == nftSold.paymentToken, "wrong payment token");

    // Check payment approval and buyer balance
    IERC20 paymentContract = IERC20(nftSold.paymentToken);
    require(
      paymentContract.balanceOf(_msgSender()) >= nftSold.price,
      "buyer doesn't have enough token to buy this item"
    );
    require(
      paymentContract.allowance(_msgSender(), address(this)) >= nftSold.price,
      "buyer doesn't approve marketplace to spend payment amount"
    );

    // We divide by 10000 to support decimal value such as 4.25% => 425 / 10000
    uint256 fee = transactionFee.mul(nftSold.price).div(10000);
    uint256 payToSellerAmount = nftSold.price.sub(fee);

    // transfer money to seller
    paymentContract.safeTransferFrom(
      _msgSender(),
      nftSold.owner,
      payToSellerAmount
    );

    // transfer fee to address
    if (fee > 0) {
      paymentContract.safeTransferFrom(_msgSender(), feeToAddress, fee);
    }

    // transfer item to buyer
    IERC721 nft = IERC721(nftSold.nftAddress);
    nft.safeTransferFrom(address(this), _msgSender(), nftSold.tokenId);

    // change state
    delete sellingBId[_id];

    emit SuccessfullyBuy(
      nftSold.tokenId,
      nftSold.nftAddress,
      nftSold.price,
      nftSold.paymentToken,
      nftSold.owner,
      _msgSender(),
      transactionFee
    );

    return true;
  }

  /* ========== VERIFY FUNCTIONS ========== */

  function verifySellingSignature(
    uint256 _id,
    address _nftAddress,
    address _paymentToken,
    uint256 _tokenId,
    uint256 _price,
    uint256 _expiredAt,
    bytes calldata _signature
  ) public view {
    bytes32 criteriaMessageHash = keccak256(
      abi.encodePacked(
        _id,
        _nftAddress,
        _tokenId,
        _paymentToken,
        _price,
        _expiredAt
      )
    );
    bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(
      criteriaMessageHash
    );

    require(
      ECDSA.recover(ethSignedMessageHash, _signature) == signer,
      "invalid signature"
    );
  }
}
