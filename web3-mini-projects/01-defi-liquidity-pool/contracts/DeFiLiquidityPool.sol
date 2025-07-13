// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./interfaces/ILiquidityPool.sol";
import "./libraries/LiquidityMath.sol";

/**
 * @title Advanced DeFi Liquidity Pool
 * @notice Liquidity pool with automatic rebalancing, dynamic fees, and advanced features
 * @dev Contract for demonstrating advanced testing with controlled vulnerabilities
 */
contract DeFiLiquidityPool is ILiquidityPool, ReentrancyGuard, Ownable, Pausable {
    using SafeERC20 for IERC20;

    // ============ State Variables ============
    
    IERC20 public immutable tokenA;
    IERC20 public immutable tokenB;
    
    uint256 public reserveA;
    uint256 public reserveB;
    uint256 public totalLiquidityTokens;
    
    mapping(address => uint256) public liquidityTokens;
    
    // Advanced configuration
    uint256 public constant MINIMUM_LIQUIDITY = 10**3;
    uint256 public constant FEE_DENOMINATOR = 10000;
    uint256 public dynamicFeeRate = 30; // 0.3% initial
    uint256 public maxSlippageProtection = 2000; // 20% for educational testing
    
    // Automatic rebalancing
    uint256 public rebalanceThreshold = 2000; // 20%
    uint256 public lastRebalanceTime;
    uint256 public rebalanceInterval = 1 hours;
    
    // MEV Protection
    mapping(address => uint256) public lastTransactionBlock;
    uint256 public frontRunProtectionBlocks = 0; // Disabled for testing
    
    // Accumulated fees
    uint256 public accumulatedFeesA;
    uint256 public accumulatedFeesB;
    
    // Oracle price (simulated)
    uint256 public oraclePrice = 1e18; // 1:1 ratio initial
    uint256 public oraclePriceLastUpdate;
    
    // Emergency controls
    bool public emergencyMode;
    
    // ============ Events ============
    // Events are defined in the interface to avoid duplication
    
    // ============ Modifiers ============
    
    modifier noFrontRun() {
        if (frontRunProtectionBlocks > 0) {
            require(
                lastTransactionBlock[msg.sender] + frontRunProtectionBlocks <= block.number,
                "Front-run protection active"
            );
        }
        lastTransactionBlock[msg.sender] = block.number;
        _;
    }
    
    modifier notInEmergency() {
        require(!emergencyMode, "Emergency mode active");
        _;
    }
    

    
    // ============ Constructor ============
    
    constructor(
        IERC20 _tokenA,
        IERC20 _tokenB,
        address _owner
    ) Ownable(_owner) {
        require(address(_tokenA) != address(0), "TokenA cannot be zero address");
        require(address(_tokenB) != address(0), "TokenB cannot be zero address");
        require(_tokenA != _tokenB, "Tokens must be different");
        
        tokenA = _tokenA;
        tokenB = _tokenB;
        lastRebalanceTime = block.timestamp;
        oraclePriceLastUpdate = block.timestamp;
    }
    
    // ============ Liquidity Functions ============
    
    /**
     * @notice Add liquidity to the pool
     * @param amountA Amount of token A
     * @param amountB Amount of token B
     * @param minLiquidity Minimum liquidity tokens expected
     * @return liquidity Liquidity tokens received
     */
    function addLiquidity(
        uint256 amountA,
        uint256 amountB,
        uint256 minLiquidity
    ) external nonReentrant whenNotPaused notInEmergency returns (uint256 liquidity) {
        require(amountA > 0 && amountB > 0, "Invalid amounts");
        
        // Transfer tokens
        tokenA.safeTransferFrom(msg.sender, address(this), amountA);
        tokenB.safeTransferFrom(msg.sender, address(this), amountB);
        
        // Calculate liquidity
        if (totalLiquidityTokens == 0) {
            liquidity = LiquidityMath.sqrt(amountA * amountB) - MINIMUM_LIQUIDITY;
            totalLiquidityTokens = MINIMUM_LIQUIDITY; // Lock minimum liquidity
        } else {
            liquidity = LiquidityMath.min(
                (amountA * totalLiquidityTokens) / reserveA,
                (amountB * totalLiquidityTokens) / reserveB
            );
        }
        
        require(liquidity >= minLiquidity, "Insufficient liquidity minted");
        require(liquidity > 0, "Insufficient liquidity");
        
        // Update state
        liquidityTokens[msg.sender] += liquidity;
        totalLiquidityTokens += liquidity;
        reserveA += amountA;
        reserveB += amountB;
        
        emit LiquidityAdded(msg.sender, amountA, amountB, liquidity);
    }
    
    /**
     * @notice Remove liquidity from the pool
     * @param liquidity Amount of liquidity tokens to burn
     * @param minAmountA Minimum amount of token A expected
     * @param minAmountB Minimum amount of token B expected
     * @return amountA Amount of token A received
     * @return amountB Amount of token B received
     */
    function removeLiquidity(
        uint256 liquidity,
        uint256 minAmountA,
        uint256 minAmountB
    ) external nonReentrant returns (uint256 amountA, uint256 amountB) {
        require(liquidity > 0, "Invalid liquidity amount");
        require(liquidityTokens[msg.sender] >= liquidity, "Insufficient liquidity tokens");
        
        // Calculate amounts to withdraw
        uint256 totalSupply = totalLiquidityTokens;
        amountA = (liquidity * reserveA) / totalSupply;
        amountB = (liquidity * reserveB) / totalSupply;
        
        require(amountA >= minAmountA, "Insufficient amount A");
        require(amountB >= minAmountB, "Insufficient amount B");
        
        // Update state
        liquidityTokens[msg.sender] -= liquidity;
        totalLiquidityTokens -= liquidity;
        reserveA -= amountA;
        reserveB -= amountB;
        
        // Transfer tokens
        tokenA.safeTransfer(msg.sender, amountA);
        tokenB.safeTransfer(msg.sender, amountB);
        
        emit LiquidityRemoved(msg.sender, amountA, amountB, liquidity);
    }
    
    // ============ Swap Functions ============
    
    /**
     * @notice Swap tokens
     * @param tokenIn Input token address
     * @param amountIn Input amount
     * @param minAmountOut Minimum output amount expected
     * @return amountOut Output amount received
     */
    function swap(
        address tokenIn,
        uint256 amountIn,
        uint256 minAmountOut
    ) external nonReentrant whenNotPaused notInEmergency noFrontRun returns (uint256 amountOut) {
        require(amountIn > 0, "Invalid input amount");
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Invalid token");
        
        // Update dynamic fees based on volatility
        _updateDynamicFees();
        
        // Calculate output with fees
        bool isTokenA = tokenIn == address(tokenA);
        uint256 reserveIn = isTokenA ? reserveA : reserveB;
        uint256 reserveOut = isTokenA ? reserveB : reserveA;
        
        // Apply dynamic fee
        uint256 amountInWithFee = amountIn * (FEE_DENOMINATOR - dynamicFeeRate) / FEE_DENOMINATOR;
        amountOut = LiquidityMath.getAmountOut(amountInWithFee, reserveIn, reserveOut);
        
        require(amountOut >= minAmountOut, "Insufficient output amount");
        require(amountOut > 0, "Invalid output amount");
        
        // Protection against extreme slippage
        uint256 priceImpact = LiquidityMath.calculatePriceImpact(amountIn, reserveIn, reserveOut);
        require(priceImpact <= maxSlippageProtection, "Price impact too high");
        
        // Transfer tokens
        IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), amountIn);
        
        // Calculate and accumulate fees
        uint256 feeAmount = amountIn * dynamicFeeRate / FEE_DENOMINATOR;
        if (isTokenA) {
            accumulatedFeesA += feeAmount;
            reserveA += amountIn;
            reserveB -= amountOut;
            tokenB.safeTransfer(msg.sender, amountOut);
        } else {
            accumulatedFeesB += feeAmount;
            reserveB += amountIn;
            reserveA -= amountOut;
            tokenA.safeTransfer(msg.sender, amountOut);
        }
        
        // Trigger rebalance if necessary
        _checkAndTriggerRebalance();
        
        emit Swap(msg.sender, tokenIn, isTokenA ? address(tokenB) : address(tokenA), amountIn, amountOut);
    }
    
    // ============ Advanced Features ============
    
    /**
     * @notice Update dynamic fees based on volatility
     */
    function _updateDynamicFees() private {
        // Simulate volatility calculation based on price changes
        uint256 currentPrice = getCurrentPrice();
        uint256 priceChange = currentPrice > oraclePrice ? 
            currentPrice - oraclePrice : oraclePrice - currentPrice;
        
        uint256 volatility = (priceChange * 10000) / oraclePrice;
        
        // Adjust dynamic fee (between 0.1% and 1%)
        uint256 newFeeRate = 10 + (volatility * 90 / 1000); // Min 0.1%, max 1%
        if (newFeeRate > 100) newFeeRate = 100; // Cap at 1%
        
        if (newFeeRate != dynamicFeeRate) {
            dynamicFeeRate = newFeeRate;
            emit DynamicFeeUpdated(newFeeRate);
        }
    }
    
    /**
     * @notice Check and execute automatic rebalancing
     */
    function _checkAndTriggerRebalance() private {
        if (block.timestamp < lastRebalanceTime + rebalanceInterval) return;
        
        uint256 targetRatio = 1e18; // 1:1 ratio target
        
        // Calculate imbalance
        uint256 currentRatio = (reserveA * 1e18) / reserveB;
        uint256 imbalance = currentRatio > targetRatio ? 
            currentRatio - targetRatio : targetRatio - currentRatio;
        
        // If imbalance is greater than threshold, rebalance
        if (imbalance > (targetRatio * rebalanceThreshold / 10000)) {
            _executeRebalance();
        }
    }
    
    /**
     * @notice Execute automatic rebalancing
     */
    function _executeRebalance() private {
        // Simplified rebalancing - in production you'd use external oracles
        uint256 targetA = (reserveA + reserveB) / 2;
        uint256 targetB = (reserveA + reserveB) / 2;
        
        // Apply gradual changes to avoid manipulation
        uint256 adjustmentA = (targetA - reserveA) / 10; // 10% of adjustment
        uint256 adjustmentB = (targetB - reserveB) / 10;
        
        reserveA += adjustmentA;
        reserveB += adjustmentB;
        
        lastRebalanceTime = block.timestamp;
        
        emit RebalanceTriggered(reserveA, reserveB);
    }
    
    /**
     * @notice Get current price based on reserves
     * @return price Current price of tokenA in terms of tokenB
     */
    function getCurrentPrice() public view returns (uint256 price) {
        if (reserveB == 0) return oraclePrice;
        return (reserveA * 1e18) / reserveB;
    }
    
    // ============ Flash Loan (Vulnerable) ============
    
    /**
     * @notice Simple flash loan - VULNERABLE for demos
     * @param amount Amount to borrow
     * @param isTokenA Whether to borrow token A or B
     */
    function flashLoan(
        uint256 amount,
        bool isTokenA
    ) external nonReentrant {
        require(amount > 0, "Invalid amount");
        
        uint256 balanceBefore = isTokenA ? 
            tokenA.balanceOf(address(this)) : 
            tokenB.balanceOf(address(this));
        
        require(balanceBefore >= amount, "Insufficient liquidity");
        
        // Transfer tokens (vulnerable - no fee)
        if (isTokenA) {
            tokenA.safeTransfer(msg.sender, amount);
        } else {
            tokenB.safeTransfer(msg.sender, amount);
        }
        
        // Callback to user
        IFlashLoanReceiver(msg.sender).receiveFlashLoan(
            isTokenA ? address(tokenA) : address(tokenB),
            amount
        );
        
        // Verify repayment (vulnerable - no fee)
        uint256 balanceAfter = isTokenA ? 
            tokenA.balanceOf(address(this)) : 
            tokenB.balanceOf(address(this));
        
        require(balanceAfter >= balanceBefore, "Flash loan not repaid");
    }
    
    // ============ Emergency Functions ============
    
    /**
     * @notice Activate emergency mode
     */
    function activateEmergencyMode() external onlyOwner {
        emergencyMode = true;
        emit EmergencyModeActivated();
    }
    
    /**
     * @notice Pause the contract
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @notice Unpause the contract
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    // ============ Admin Functions ============
    
    /**
     * @notice Update oracle price (simulated)
     */
    function updateOraclePrice(uint256 _newPrice) external onlyOwner {
        require(_newPrice > 0, "Invalid price");
        oraclePrice = _newPrice;
        oraclePriceLastUpdate = block.timestamp;
        emit OraclePriceUpdated(_newPrice);
    }
    
    /**
     * @notice Withdraw accumulated fees
     */
    function withdrawFees() external onlyOwner {
        uint256 feesA = accumulatedFeesA;
        uint256 feesB = accumulatedFeesB;
        
        accumulatedFeesA = 0;
        accumulatedFeesB = 0;
        
        if (feesA > 0) tokenA.safeTransfer(owner(), feesA);
        if (feesB > 0) tokenB.safeTransfer(owner(), feesB);
    }
    
    /**
     * @notice Set MEV protection for testing
     * @param _maxSlippage Maximum slippage protection in basis points
     * @param _frontRunBlocks Front-run protection blocks
     */
    function setMEVProtection(uint256 _maxSlippage, uint256 _frontRunBlocks) external onlyOwner {
        maxSlippageProtection = _maxSlippage;
        frontRunProtectionBlocks = _frontRunBlocks;
    }
    
    // ============ View Functions ============
    
    /**
     * @notice Get current reserves
     */
    function getReserves() external view returns (uint256 _reserveA, uint256 _reserveB) {
        return (reserveA, reserveB);
    }
    
    /**
     * @notice Calculate output amount for a swap
     */
    function getAmountOut(
        uint256 amountIn,
        bool isTokenA
    ) external view returns (uint256 amountOut) {
        require(amountIn > 0, "Invalid input amount");
        
        uint256 reserveIn = isTokenA ? reserveA : reserveB;
        uint256 reserveOut = isTokenA ? reserveB : reserveA;
        
        uint256 amountInWithFee = amountIn * (FEE_DENOMINATOR - dynamicFeeRate) / FEE_DENOMINATOR;
        return LiquidityMath.getAmountOut(amountInWithFee, reserveIn, reserveOut);
    }
    
    /**
     * @notice Get user information
     */
    function getUserInfo(address user) external view returns (
        uint256 liquidityBalance,
        uint256 sharePercentage,
        uint256 estimatedValueA,
        uint256 estimatedValueB
    ) {
        liquidityBalance = liquidityTokens[user];
        
        if (totalLiquidityTokens > 0) {
            sharePercentage = (liquidityBalance * 10000) / totalLiquidityTokens;
            estimatedValueA = (liquidityBalance * reserveA) / totalLiquidityTokens;
            estimatedValueB = (liquidityBalance * reserveB) / totalLiquidityTokens;
        }
    }
}

// ============ Interfaces ============

interface IFlashLoanReceiver {
    function receiveFlashLoan(address token, uint256 amount) external;
} 