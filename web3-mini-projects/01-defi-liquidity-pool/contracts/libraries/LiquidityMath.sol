// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title LiquidityMath
 * @notice Mathematical library for liquidity pool calculations
 * @dev Includes AMM formulas, price calculations, and impact analysis
 */
library LiquidityMath {
    
    // ============ Constants ============
    
    uint256 private constant MAX_UINT256 = type(uint256).max;
    
    // ============ Core AMM Functions ============
    
    /**
     * @notice Calculate output amount for a swap using x * y = k formula
     * @param amountIn Input amount
     * @param reserveIn Reserve of input token
     * @param reserveOut Reserve of output token
     * @return amountOut Output amount
     */
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, "LiquidityMath: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "LiquidityMath: INSUFFICIENT_LIQUIDITY");
        
        uint256 numerator = amountIn * reserveOut;
        uint256 denominator = reserveIn + amountIn;
        amountOut = numerator / denominator;
    }
    
    /**
     * @notice Calculate input amount needed to get specific output amount
     * @param amountOut Desired output amount
     * @param reserveIn Reserve of input token
     * @param reserveOut Reserve of output token
     * @return amountIn Required input amount
     */
    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountIn) {
        require(amountOut > 0, "LiquidityMath: INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "LiquidityMath: INSUFFICIENT_LIQUIDITY");
        require(amountOut < reserveOut, "LiquidityMath: INSUFFICIENT_RESERVE_OUT");
        
        uint256 numerator = reserveIn * amountOut;
        uint256 denominator = reserveOut - amountOut;
        amountIn = (numerator / denominator) + 1;
    }
    
    // ============ Price Impact Functions ============
    
    /**
     * @notice Calculate price impact of a swap
     * @param amountIn Input amount
     * @param reserveIn Reserve of input token
     * @param reserveOut Reserve of output token
     * @return priceImpact Price impact in basis points (10000 = 100%)
     */
    function calculatePriceImpact(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 priceImpact) {
        require(amountIn > 0, "LiquidityMath: INVALID_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "LiquidityMath: INVALID_RESERVES");
        
        // Price before swap
        uint256 priceBefore = (reserveOut * 1e18) / reserveIn;
        
        // Price after swap
        uint256 newReserveIn = reserveIn + amountIn;
        uint256 amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
        uint256 newReserveOut = reserveOut - amountOut;
        
        if (newReserveOut == 0) return 10000; // 100% impact
        
        uint256 priceAfter = (newReserveOut * 1e18) / newReserveIn;
        
        // Calculate impact in basis points
        if (priceAfter >= priceBefore) {
            priceImpact = ((priceAfter - priceBefore) * 10000) / priceBefore;
        } else {
            priceImpact = ((priceBefore - priceAfter) * 10000) / priceBefore;
        }
    }
    
    /**
     * @notice Calculate current pool price
     * @param reserveA Reserve of token A
     * @param reserveB Reserve of token B
     * @return price Price of A in terms of B
     */
    function getPrice(
        uint256 reserveA,
        uint256 reserveB
    ) internal pure returns (uint256 price) {
        require(reserveA > 0 && reserveB > 0, "LiquidityMath: INVALID_RESERVES");
        return (reserveB * 1e18) / reserveA;
    }
    
    // ============ Utility Functions ============
    
    /**
     * @notice Square root function using Babylonian method
     * @param y Number to calculate square root of
     * @return z Square root result
     */
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
    
    /**
     * @notice Return the minimum of two numbers
     * @param a First number
     * @param b Second number
     * @return Minimum number
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    
    /**
     * @notice Return the maximum of two numbers
     * @param a First number
     * @param b Second number
     * @return Maximum number
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }
    
    // ============ Advanced Math Functions ============
    
    /**
     * @notice Calculate optimal liquidity to maintain proportions
     * @param amountA Amount of token A
     * @param amountB Amount of token B
     * @param reserveA Current reserve of token A
     * @param reserveB Current reserve of token B
     * @return optimalAmountA Optimal amount of token A
     * @return optimalAmountB Optimal amount of token B
     */
    function calculateOptimalLiquidity(
        uint256 amountA,
        uint256 amountB,
        uint256 reserveA,
        uint256 reserveB
    ) internal pure returns (uint256 optimalAmountA, uint256 optimalAmountB) {
        if (reserveA == 0 && reserveB == 0) {
            return (amountA, amountB);
        }
        
        uint256 amountBOptimal = (amountA * reserveB) / reserveA;
        if (amountBOptimal <= amountB) {
            return (amountA, amountBOptimal);
        } else {
            uint256 amountAOptimal = (amountB * reserveA) / reserveB;
            return (amountAOptimal, amountB);
        }
    }
    
    /**
     * @notice Calculate impermanent loss
     * @param initialPriceRatio Initial price ratio
     * @param currentPriceRatio Current price ratio
     * @return impermanentLoss Impermanent loss in basis points
     */
    function calculateImpermanentLoss(
        uint256 initialPriceRatio,
        uint256 currentPriceRatio
    ) internal pure returns (uint256 impermanentLoss) {
        require(initialPriceRatio > 0, "LiquidityMath: INVALID_INITIAL_PRICE");
        require(currentPriceRatio > 0, "LiquidityMath: INVALID_CURRENT_PRICE");
        
        // Formula: IL = 2 * sqrt(ratio) / (1 + ratio) - 1
        uint256 ratio = (currentPriceRatio * 1e18) / initialPriceRatio;
        uint256 sqrtRatio = sqrt(ratio);
        uint256 numerator = 2 * sqrtRatio;
        uint256 denominator = 1e18 + ratio;
        
        uint256 value = (numerator * 1e18) / denominator;
        
        if (value >= 1e18) {
            impermanentLoss = 0;
        } else {
            impermanentLoss = ((1e18 - value) * 10000) / 1e18;
        }
    }
    
    /**
     * @notice Calculate fee APR
     * @param feeAmount Amount of fees earned
     * @param liquidityValue Value of liquidity provided
     * @param timeElapsed Time elapsed in seconds
     * @return aprBasisPoints APR in basis points
     */
    function calculateFeeAPR(
        uint256 feeAmount,
        uint256 liquidityValue,
        uint256 timeElapsed
    ) internal pure returns (uint256 aprBasisPoints) {
        require(liquidityValue > 0, "LiquidityMath: INVALID_LIQUIDITY_VALUE");
        require(timeElapsed > 0, "LiquidityMath: INVALID_TIME");
        
        // Calculate APR: (feeAmount / liquidityValue) * (365 days / timeElapsed) * 10000
        uint256 feeRatio = (feeAmount * 1e18) / liquidityValue;
        uint256 annualizedRatio = (feeRatio * 365 days) / timeElapsed;
        aprBasisPoints = (annualizedRatio * 10000) / 1e18;
    }
    
    /**
     * @notice Check if multiplication is safe from overflow
     * @param a First number
     * @param b Second number
     * @return True if safe to multiply
     */
    function safeMul(uint256 a, uint256 b) internal pure returns (bool) {
        if (a == 0) return true;
        return (MAX_UINT256 / a) >= b;
    }
    
    /**
     * @notice Calculate slippage for an operation
     * @param expectedAmount Expected amount
     * @param actualAmount Actual amount
     * @return slippage Slippage in basis points
     */
    function calculateSlippage(
        uint256 expectedAmount,
        uint256 actualAmount
    ) internal pure returns (uint256 slippage) {
        require(expectedAmount > 0, "LiquidityMath: INVALID_EXPECTED_AMOUNT");
        
        if (actualAmount >= expectedAmount) {
            return 0; // No negative slippage
        }
        
        uint256 difference = expectedAmount - actualAmount;
        slippage = (difference * 10000) / expectedAmount;
    }
    
    /**
     * @notice Calculate capital efficiency
     * @param totalValueLocked TVL in the pool
     * @param volume24h 24-hour volume
     * @return efficiency Capital efficiency (volume/TVL ratio)
     */
    function calculateCapitalEfficiency(
        uint256 totalValueLocked,
        uint256 volume24h
    ) internal pure returns (uint256 efficiency) {
        require(totalValueLocked > 0, "LiquidityMath: INVALID_TVL");
        return (volume24h * 1e18) / totalValueLocked;
    }
} 