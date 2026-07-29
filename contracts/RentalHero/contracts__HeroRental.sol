// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: HeroRental
// Verified name: RentalHero
// Address: 
// Compiler: v0.8.0+commit.c7dfd78e
// Source file: contracts/HeroRental.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';

interface IThetanHero {
  function lock(uint256 tokenId) external;

  function unlock(uint256 tokenId) external;

  function ownerOf(uint256 tokenId) external returns (address);
}

contract HeroRental is Ownable {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  event RentHero(address indexed owner, address indexed renter, uint256 indexed tokenId, uint256 price, address paymentToken, uint256 fee);
  event UnlockHero(uint256 indexed tokenId);
  event CancelSignature(uint256 tokenId);

  address public feeToAddress;
  uint256 public rentalFee;

  mapping(bytes => bool) public usedSignatures;

  function setFeeToAddress(address _feeToAddress) public onlyOwner {
    feeToAddress = _feeToAddress;
  }

  function setRentalFee(uint256 _rentalFee) public onlyOwner {
    rentalFee = _rentalFee;
  }

  function cancelSignature(
    uint256[3] calldata values, // 0: _tokenId, 1: _price, 2: _saltNonce
    address paymentErc20,
    bytes calldata signature
  ) public {
    require(!usedSignatures[signature], 'HeroRental: this signature is used');
    bytes32 criteriaMessageHash = getMessageHash(values[0], values[1], paymentErc20, values[2]);
    bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(criteriaMessageHash);
    require(ECDSA.recover(ethSignedMessageHash, signature) == _msgSender(), 'HeroRental: invalid heroOwner signature');

    usedSignatures[signature] = true;
    emit CancelSignature(values[0]);
  }

  /**
   * @dev rent hero
   */
  function rentHero(
    address[3] calldata addresses, // 0: heroOwner, 1: paymentErc20, 2: thetanHero
    uint256[3] calldata values, // 0: _tokenId, 1: _price, 2: _saltNonce
    bytes calldata signature
  ) external {
    require(values[1] > 0, 'HeroRental: Invalid payment amount');
    require(!usedSignatures[signature], 'HeroRental: signature is used or canceled. please send another transaction with new signature');

    bytes32 criteriaMessageHash = getMessageHash(values[0], values[1], addresses[1], values[2]);
    bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(criteriaMessageHash);
    require(ECDSA.recover(ethSignedMessageHash, signature) == addresses[0], 'HeroRental: invalid heroOwner signature');

    IERC20 paymentContract = IERC20(addresses[1]);
    require(paymentContract.balanceOf(_msgSender()) >= values[1], "HeroRental: renter doesn't have enough token to rent this item");
    require(paymentContract.allowance(_msgSender(), address(this)) >= values[1], "HeroRental: renter doesn't approve HeroRental to spend payment amount");

    // lock thetan hero
    IThetanHero nft = IThetanHero(addresses[2]);
    require(nft.ownerOf(values[0]) == addresses[0], 'HeroRental: HeroOwner is not owner of this item now');
    nft.lock(values[0]);

    // Transfer payment to owner and fee to address
    uint256 fee = rentalFee.mul(values[1]).div(10000);
    uint256 payToOwner = values[1].sub(fee);
    paymentContract.safeTransferFrom(_msgSender(), addresses[0], payToOwner);
    if (fee > 0) {
      paymentContract.safeTransferFrom(_msgSender(), feeToAddress, fee);
    }

    // set used signature
    usedSignatures[signature] = true;

    // Emit rent event
    emit RentHero(addresses[0], _msgSender(), values[0], values[1], addresses[1], rentalFee);
  }

  /**
   * @dev unlock rented hero
   */
  function unlockHero(address thetanHero, uint256 tokenId) public onlyOwner {
    IThetanHero nft = IThetanHero(thetanHero);
    nft.unlock(tokenId);
    // Emit rent event
    emit UnlockHero(tokenId);
  }

  function getMessageHash(
    uint256 _tokenId,
    uint256 _price,
    address _paymentErc20,
    uint256 _saltNonce
  ) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(_tokenId, _price, _paymentErc20, _saltNonce));
  }
}
