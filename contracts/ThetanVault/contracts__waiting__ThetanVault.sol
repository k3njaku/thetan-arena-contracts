// SPDX-License-Identifier: MIT
// ============================================================================
// Contract: ThetanVault
// Verified name: ThetanVault
// Address: 
// Compiler: v0.8.20+commit.a1b79de6
// Source file: contracts/waiting/ThetanVault.sol
// Fetched from BscScan (BSC mainnet, chainId 56)
// ============================================================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract ThetanVault is Pausable, AccessControl, ReentrancyGuard {
    using SafeERC20 for IERC20;
    
    struct BatchTransfer {
        address []to;
        uint256 []amount;
    }

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");

    // Mapping from user addresses to token addresses to balances
    mapping(address => mapping(address => uint256)) private _balances;

    // Events
    event BalanceChanged(address user, address token, uint256 newBalance);
    event BalancesChanged(address[] users, address token, uint256[] newBalances);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        // _grantRole(TRANSFER_ROLE, msg.sender); // Grant transfer role to defaultAdmin
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function deposit(address token, uint256 amount) public whenNotPaused nonReentrant {
        require(amount > 0, "ThetanVault: Amount must be greater than 0");

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        _balances[msg.sender][token] += amount;

        emit BalanceChanged(msg.sender, token, _balances[msg.sender][token]);
    }

    function withdraw(address token, uint256 amount) public whenNotPaused nonReentrant {
        require(amount > 0, "ThetanVault: Amount must be greater than 0");
        require(_balances[msg.sender][token] >= amount, "ThetanVault: Insufficient balance");

        _balances[msg.sender][token] -= amount;
        IERC20(token).safeTransfer(msg.sender, amount);

        emit BalanceChanged(msg.sender, token, _balances[msg.sender][token]);
    }

    function transfer(address from, address to, address token, uint256 amount) public whenNotPaused nonReentrant onlyRole(TRANSFER_ROLE) {
        require(amount > 0 && _balances[from][token] >= amount, "ThetanVault: Invalid amount");

        // Update balances
        _balances[from][token] -= amount;
        _balances[to][token] += amount;

        // Prepare data for the event
        address[] memory users = new address[](2);
        users[0] = from; users[1] = to;

        uint256[] memory newBalances = new uint256[](2);
        newBalances[0] = _balances[from][token]; newBalances[1] = _balances[to][token];

        emit BalancesChanged(users, token, newBalances); // Emit a single event for both balance changes
    }

    function transferBatchFrom(address from, address token, BatchTransfer memory batch) public whenNotPaused nonReentrant onlyRole(TRANSFER_ROLE) {
        require(batch.to.length == batch.amount.length, "ThetanVault: BatchTransfer arrays must have the same length");
        require(token != address(0), "ThetanVault: Invalid address");

        address[] memory users = new address[](batch.to.length + 1); // +1 to include 'from' at the end
        uint256[] memory newBalances = new uint256[](batch.to.length + 1);

        // Accumulate total amount to be transferred from 'from'
        uint256 balanceFrom = _balances[from][token];

        for (uint256 i = 0; i < batch.to.length; i++) {
            require(batch.amount[i] >= 0, "ThetanVault: Invalid amount");

            address to = batch.to[i];
            uint256 amount = batch.amount[i];

            if (to == from || amount == 0) {
                continue;
            }
            
            require(balanceFrom >= amount, "ThetanVault: Insufficient balance");
            balanceFrom -= amount;

            // Update balances for 'to'
            uint256 newBalance = _balances[to][token] + amount;
            _balances[to][token] = newBalance;

            // Prepare data for the event for 'to'
            users[i] = to;
            newBalances[i] = newBalance;
        }

        // Prepare for 'from'
        _balances[from][token] = balanceFrom;

        users[batch.to.length] = from;
        newBalances[batch.to.length] = balanceFrom;

        emit BalancesChanged(users, token, newBalances); 
    }

    function balanceOf(address account, address token) public view returns (uint256) {
        return _balances[account][token];
    }
}