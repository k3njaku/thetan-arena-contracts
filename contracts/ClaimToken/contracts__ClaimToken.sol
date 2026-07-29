// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: ClaimToken
// Verified name: ClaimToken
// Address: 
// Compiler: v0.8.0+commit.c7dfd78e
// Source file: contracts/ClaimToken.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

contract ClaimToken is Ownable {
  /* ========== LIBs ========== */

  using SafeERC20 for IERC20;

  /* ========== STATE VARIABLES ========== */

  address public signer;
  mapping(uint256 => bool) public ids;
  mapping(address => bool) public admins;

  /* ========== EVENTS ========== */

  event TokenClaimed(
    address tokenAddress,
    address user,
    uint256 id,
    uint256 amount
  );

  /* ========== READ FUNCTIONS ========== */

  function getClaimMessageHash(
    address tokenAddress,
    address user,
    uint256 id,
    uint256 amount,
    uint256 expiredAt
  ) public pure returns (bytes32) {
    return
      keccak256(abi.encodePacked(tokenAddress, user, id, amount, expiredAt));
  }

  function balanceOf(address tokenAddress) public view returns (uint256) {
    IERC20 token = IERC20(tokenAddress);
    return token.balanceOf(address(this));
  }

  /* ========== WRITE FUNCTIONS ========== */
  function setAdminAddress(address admin) external onlyOwner {
    admins[admin] = true;
  }

  function removeAdminAddress(address admin) external onlyOwner {
    admins[admin] = false;
  }

  function setSigner(address _signer) external onlyOwner {
    require(_signer != address(0), 'ClaimToken: invalid signer address');
    signer = _signer;
  }

  function withdrawn(address tokenAddress, uint256 amount) external onlyAdmin {
    IERC20 token = IERC20(tokenAddress);
    token.transfer(msg.sender, amount);
  }

  function claimToken(
    address tokenAddress,
    uint256 id,
    uint256 amount,
    uint256 expiredAt,
    bytes calldata signature
  ) external {
    verifyClaimTokenSignature(
      tokenAddress,
      msg.sender,
      id,
      amount,
      expiredAt,
      signature
    );
    IERC20 token = IERC20(tokenAddress);
    require(amount > 0, 'ClaimToken: amout must be greater than 0');
    require(!ids[id], 'ClaimToken: the id is used');
    require(
      block.timestamp < expiredAt,
      'ClaimToken: the signature is expired'
    );

    // check balanceOf
    require(
      token.balanceOf(address(this)) >= amount,
      'ClaimToken: not sufficient tokens'
    );
    token.safeTransfer(msg.sender, amount);

    ids[id] = true;

    emit TokenClaimed(tokenAddress, msg.sender, id, amount);
  }

  /* ========== VERIFY FUNCTIONS ========== */

  function verifyClaimTokenSignature(
    address tokenAddress,
    address sender,
    uint256 id,
    uint256 amount,
    uint256 expiredAt,
    bytes calldata signature
  ) public view {
    bytes32 criteriaMessageHash = getClaimMessageHash(
      tokenAddress,
      sender,
      id,
      amount,
      expiredAt
    );
    bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(
      criteriaMessageHash
    );
    require(
      ECDSA.recover(ethSignedMessageHash, signature) == signer,
      'ClaimToken: invalid signature'
    );
  }

  /* ========== MODIFIERS ========== */
  modifier onlyAdmin() {
    require(admins[msg.sender], 'ClaimToken: not admin');
    _;
  }
}
