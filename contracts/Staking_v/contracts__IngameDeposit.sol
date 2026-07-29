// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: IngameDeposit
// Verified name: Staking_v
// Address: 
// Compiler: v0.8.2+commit.661d1103
// Source file: contracts/IngameDeposit.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @custom:security-contact hoang@wolffungame.com
contract IngameDeposit is Ownable {
  using SafeERC20 for IERC20;

  address public wallet;
  mapping(address => bool) public erc20s;

  event Deposit(address sender, uint256 amount, address erc20);

  /* setup */
  function setWallet(address _wallet) external onlyOwner {
    require(_wallet != address(0), "IngameDeposit: invalid wallet");
    wallet = _wallet;
  }

  function addErc20(address[] calldata _erc20s) external onlyOwner {
    for (uint256 i = 0; i < _erc20s.length; i++) {
      if (erc20s[_erc20s[i]]) {
        continue;
      }

      erc20s[_erc20s[i]] = true;
    }
  }

  function removeErc20(address[] calldata removed) external onlyOwner {
    for (uint256 i = 0; i < removed.length; i++) {
      erc20s[removed[i]] = false;
    }
  }

  /* convert */
  function deposit(IERC20 _erc20, uint256 amount) public {
    require(erc20s[address(_erc20)], "IngameDeposit: erc20 is not allowed to convert");

    _erc20.safeTransferFrom(msg.sender, wallet, amount);
    emit Deposit(msg.sender, amount, address(_erc20));
  }
}