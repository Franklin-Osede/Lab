// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ILiquidityPool
 * @notice Interface for the DeFi liquidity pool
 */
interface ILiquidityPool {
    // ============ Events ============
    
    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidity);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidity);
    event Swap(address indexed user, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event RebalanceTriggered(uint256 newReserveA, uint256 newReserveB);
    event DynamicFeeUpdated(uint256 newFeeRate);
    event EmergencyModeActivated();
    event OraclePriceUpdated(uint256 newPrice);
    
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
    ) external returns (uint256 liquidity);
    
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
    ) external returns (uint256 amountA, uint256 amountB);
    
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
    ) external returns (uint256 amountOut);
    
    /**
     * @notice Execute flash loan
     * @param amount Amount to borrow
     * @param isTokenA Whether to borrow token A or B
     */
    function flashLoan(uint256 amount, bool isTokenA) external;
    
    // ============ View Functions ============
    
    /**
     * @notice Get current reserves
     */
    function getReserves() external view returns (uint256 _reserveA, uint256 _reserveB);
    
    /**
     * @notice Calculate output amount for a swap
     */
    function getAmountOut(uint256 amountIn, bool isTokenA) external view returns (uint256 amountOut);
    
    /**
     * @notice Get current price
     */
    function getCurrentPrice() external view returns (uint256 price);
    
    /**
     * @notice Get user information
     */
    function getUserInfo(address user) external view returns (
        uint256 liquidityBalance,
        uint256 sharePercentage,
        uint256 estimatedValueA,
        uint256 estimatedValueB
    );
    
    // ============ Admin Functions ============
    
    /**
     * @notice Update oracle price
     */
    function updateOraclePrice(uint256 _newPrice) external;
    
    /**
     * @notice Activate emergency mode
     */
    function activateEmergencyMode() external;
    
    /**
     * @notice Pause the contract
     */
    function pause() external;
    
    /**
     * @notice Unpause the contract
     */
    function unpause() external;
    
    /**
     * @notice Withdraw accumulated fees
     */
    function withdrawFees() external;
} 