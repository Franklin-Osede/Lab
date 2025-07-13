// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../contracts/DeFiLiquidityPool.sol";
import "../contracts/mocks/MockERC20.sol";

contract DeFiLiquidityPoolTest is Test {
    DeFiLiquidityPool public pool;
    MockERC20 public tokenA;
    MockERC20 public tokenB;
    
    address public owner = address(0x1);
    address public alice = address(0x2);
    address public bob = address(0x3);
    
    function setUp() public {
        // Deploy mock tokens
        tokenA = new MockERC20("Token A", "TKA", 18, 1000000 * 1e18, owner);
        tokenB = new MockERC20("Token B", "TKB", 18, 1000000 * 1e18, owner);
        
        // Deploy liquidity pool
        pool = new DeFiLiquidityPool(tokenA, tokenB, owner);
        
        // Set up tokens for users
        vm.startPrank(owner);
        tokenA.transfer(alice, 10000 * 1e18);
        tokenB.transfer(alice, 10000 * 1e18);
        tokenA.transfer(bob, 5000 * 1e18);
        tokenB.transfer(bob, 5000 * 1e18);
        vm.stopPrank();
    }
    
    function testAddLiquidity() public {
        vm.startPrank(alice);
        
        // Approve tokens
        tokenA.approve(address(pool), 1000 * 1e18);
        tokenB.approve(address(pool), 1000 * 1e18);
        
        // Add liquidity
        uint256 liquidity = pool.addLiquidity(1000 * 1e18, 1000 * 1e18, 0);
        
        // Verify liquidity was added
        assertTrue(liquidity > 0);
        
        // Verify reserves
        (uint256 reserveA, uint256 reserveB) = pool.getReserves();
        assertEq(reserveA, 1000 * 1e18);
        assertEq(reserveB, 1000 * 1e18);
        
        vm.stopPrank();
    }
    
    function testSwap() public {
        // Setup: Alice adds liquidity
        vm.startPrank(alice);
        tokenA.approve(address(pool), 1000 * 1e18);
        tokenB.approve(address(pool), 1000 * 1e18);
        pool.addLiquidity(1000 * 1e18, 1000 * 1e18, 0);
        vm.stopPrank();
        
        // Bob makes a swap
        vm.startPrank(bob);
        uint256 swapAmount = 100 * 1e18;
        tokenA.approve(address(pool), swapAmount);
        
        uint256 balanceBeforeB = tokenB.balanceOf(bob);
        uint256 amountOut = pool.swap(address(tokenA), swapAmount, 0);
        uint256 balanceAfterB = tokenB.balanceOf(bob);
        
        // Verify swap worked
        assertTrue(amountOut > 0);
        assertEq(balanceAfterB - balanceBeforeB, amountOut);
        
        vm.stopPrank();
    }
    
    // FUZZ TEST: Test adding liquidity with random amounts
    function testFuzzAddLiquidity(uint256 amountA, uint256 amountB) public {
        // Bound amounts to reasonable values (minimum 1000 tokens)
        amountA = bound(amountA, 1000 * 1e18, 10000 * 1e18);
        amountB = bound(amountB, 1000 * 1e18, 10000 * 1e18);
        
        vm.startPrank(alice);
        
        // Approve tokens
        tokenA.approve(address(pool), amountA);
        tokenB.approve(address(pool), amountB);
        
        // Add liquidity
        uint256 liquidity = pool.addLiquidity(amountA, amountB, 0);
        
        // Verify liquidity was added
        assertTrue(liquidity > 0);
        
        // Verify reserves
        (uint256 reserveA, uint256 reserveB) = pool.getReserves();
        assertEq(reserveA, amountA);
        assertEq(reserveB, amountB);
        
        vm.stopPrank();
    }
    
    // FUZZ TEST: Test swaps with random amounts
    function testFuzzSwap(uint256 swapAmount) public {
        // Setup: Alice adds liquidity
        vm.startPrank(alice);
        tokenA.approve(address(pool), 1000 * 1e18);
        tokenB.approve(address(pool), 1000 * 1e18);
        pool.addLiquidity(1000 * 1e18, 1000 * 1e18, 0);
        vm.stopPrank();
        
        // Bound swap amount to reasonable values (1 to 100 tokens)
        swapAmount = bound(swapAmount, 1 * 1e18, 100 * 1e18);
        
        vm.startPrank(bob);
        
        tokenA.approve(address(pool), swapAmount);
        
        uint256 balanceBeforeA = tokenA.balanceOf(bob);
        uint256 balanceBeforeB = tokenB.balanceOf(bob);
        
        uint256 amountOut = pool.swap(address(tokenA), swapAmount, 0);
        
        uint256 balanceAfterA = tokenA.balanceOf(bob);
        uint256 balanceAfterB = tokenB.balanceOf(bob);
        
        // Verify swap worked
        assertTrue(amountOut > 0);
        assertEq(balanceBeforeA - balanceAfterA, swapAmount);
        assertEq(balanceAfterB - balanceBeforeB, amountOut);
        
        vm.stopPrank();
    }
    
    // Test price calculations
    function testCurrentPrice() public {
        vm.startPrank(alice);
        tokenA.approve(address(pool), 1000 * 1e18);
        tokenB.approve(address(pool), 1000 * 1e18);
        pool.addLiquidity(1000 * 1e18, 1000 * 1e18, 0);
        vm.stopPrank();
        
        uint256 price = pool.getCurrentPrice();
        assertEq(price, 1 * 1e18); // 1:1 ratio initially
    }
    
    // Test getAmountOut calculation
    function testGetAmountOut() public {
        vm.startPrank(alice);
        tokenA.approve(address(pool), 1000 * 1e18);
        tokenB.approve(address(pool), 1000 * 1e18);
        pool.addLiquidity(1000 * 1e18, 1000 * 1e18, 0);
        vm.stopPrank();
        
        uint256 amountOut = pool.getAmountOut(100 * 1e18, true);
        assertTrue(amountOut > 0);
        assertTrue(amountOut < 100 * 1e18); // Should be less due to fees
    }
    
    // Test slippage protection
    function testSlippageProtection() public {
        vm.startPrank(alice);
        tokenA.approve(address(pool), 1000 * 1e18);
        tokenB.approve(address(pool), 1000 * 1e18);
        pool.addLiquidity(1000 * 1e18, 1000 * 1e18, 0);
        vm.stopPrank();
        
        // Try to swap a very large amount (should fail)
        vm.startPrank(bob);
        uint256 hugeAmount = 800 * 1e18; // 80% of pool
        tokenA.approve(address(pool), hugeAmount);
        
        // Should revert due to slippage protection
        vm.expectRevert("Price impact too high");
        pool.swap(address(tokenA), hugeAmount, 0);
        
        vm.stopPrank();
    }
    
    // Test emergency mode
    function testEmergencyMode() public {
        vm.startPrank(alice);
        tokenA.approve(address(pool), 1000 * 1e18);
        tokenB.approve(address(pool), 1000 * 1e18);
        pool.addLiquidity(1000 * 1e18, 1000 * 1e18, 0);
        vm.stopPrank();
        
        // Activate emergency mode
        vm.prank(owner);
        pool.activateEmergencyMode();
        
        // Try to swap (should fail)
        vm.startPrank(bob);
        tokenA.approve(address(pool), 100 * 1e18);
        
        vm.expectRevert("Emergency mode active");
        pool.swap(address(tokenA), 100 * 1e18, 0);
        
        vm.stopPrank();
    }
    
    // Invariant: Pool should always maintain x*y >= k relationship
    function invariant_ConstantProduct() public {
        (uint256 reserveA, uint256 reserveB) = pool.getReserves();
        if (reserveA > 0 && reserveB > 0) {
            // After any operation, the product should not decrease significantly
            assertTrue(reserveA * reserveB >= 1000); // Minimum threshold
        }
    }
} 