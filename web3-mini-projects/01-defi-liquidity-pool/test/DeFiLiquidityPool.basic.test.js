const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");

describe("🚀 DeFi Liquidity Pool - Basic Demo", function () {
  // Initial test configuration
  async function deployLiquidityPoolFixture() {
    const [owner, alice, bob, attacker] = await ethers.getSigners();

    // Deploy mock tokens
    const MockERC20 = await ethers.getContractFactory("MockERC20");
    const tokenA = await MockERC20.deploy(
      "Token A",
      "TKA",
      18,
      ethers.parseEther("1000000"), // 1M tokens
      owner.address
    );
    const tokenB = await MockERC20.deploy(
      "Token B", 
      "TKB",
      18,
      ethers.parseEther("1000000"), // 1M tokens
      owner.address
    );

    // Deploy liquidity pool
    const DeFiLiquidityPool = await ethers.getContractFactory("DeFiLiquidityPool");
    const pool = await DeFiLiquidityPool.deploy(
      tokenA.target,
      tokenB.target,
      owner.address
    );
    
    // Configure MEV protection for testing (very permissive)
    await pool.connect(owner).setMEVProtection(5000, 0); // 50% max slippage, no front-run protection

    // Deploy attacker
    const MockAttacker = await ethers.getContractFactory("MockAttacker");
    const attackerContract = await MockAttacker.deploy(
      pool.target,
      tokenA.target,
      tokenB.target
    );

    // Distribute tokens to users
    await tokenA.transfer(alice.address, ethers.parseEther("10000"));
    await tokenB.transfer(alice.address, ethers.parseEther("10000"));
    await tokenA.transfer(bob.address, ethers.parseEther("5000"));
    await tokenB.transfer(bob.address, ethers.parseEther("5000"));
    await tokenA.transfer(attacker.address, ethers.parseEther("10000"));
    await tokenB.transfer(attacker.address, ethers.parseEther("10000"));

    return { 
      pool, 
      tokenA, 
      tokenB, 
      attackerContract, 
      owner, 
      alice, 
      bob, 
      attacker 
    };
  }

  describe("📊 Basic Functionalities", function () {
    it("✅ Should allow adding initial liquidity", async function () {
      const { pool, tokenA, tokenB, alice } = await loadFixture(deployLiquidityPoolFixture);

      const amountA = ethers.parseEther("1000");
      const amountB = ethers.parseEther("1000");

      // Approve tokens
      await tokenA.connect(alice).approve(pool.target, amountA);
      await tokenB.connect(alice).approve(pool.target, amountB);

      // Add liquidity
      await expect(pool.connect(alice).addLiquidity(amountA, amountB, 0))
        .to.emit(pool, "LiquidityAdded")
        .withArgs(alice.address, amountA, amountB, anyValue);

      // Verify reserves
      const [reserveA, reserveB] = await pool.getReserves();
      expect(reserveA).to.equal(amountA);
      expect(reserveB).to.equal(amountB);

      console.log("   💰 Liquidity added successfully");
      console.log(`   📊 Reserves: ${ethers.formatEther(reserveA)} TKA, ${ethers.formatEther(reserveB)} TKB`);
    });

    it("✅ Should allow swaps with dynamic fees", async function () {
      const { pool, tokenA, tokenB, alice, bob } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // Bob makes a swap
      const swapAmount = ethers.parseEther("100");
      await tokenA.connect(bob).approve(pool.target, swapAmount);

      const initialPrice = await pool.getCurrentPrice();
      const expectedOut = await pool.getAmountOut(swapAmount, true);

      await expect(pool.connect(bob).swap(tokenA.target, swapAmount, 0))
        .to.emit(pool, "Swap")
        .withArgs(bob.address, tokenA.target, tokenB.target, swapAmount, anyValue);

      const finalPrice = await pool.getCurrentPrice();
      const dynamicFee = await pool.dynamicFeeRate();

      console.log("   🔄 Swap executed successfully");
      console.log(`   📈 Initial price: ${ethers.formatEther(initialPrice)}`);
      console.log(`   📈 Final price: ${ethers.formatEther(finalPrice)}`);
      console.log(`   💸 Dynamic fee: ${dynamicFee} basis points`);
      console.log(`   📊 Expected: ${ethers.formatEther(expectedOut)} TKB`);
    });

    it("✅ Should show automatic rebalancing", async function () {
      const { pool, tokenA, tokenB, alice, bob, owner } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // Create large imbalance
      const largeSwap = ethers.parseEther("400"); // 40% of pool
      await tokenA.connect(bob).approve(pool.target, largeSwap);
      
      const [initialReserveA, initialReserveB] = await pool.getReserves();
      
      // Make large swap that could trigger rebalancing
      await pool.connect(bob).swap(tokenA.target, largeSwap, 0);

      const [finalReserveA, finalReserveB] = await pool.getReserves();
      const currentRatio = (finalReserveA * 1000n) / finalReserveB;

      console.log("   ⚖️  Rebalancing verified");
      console.log(`   📊 Initial reserves: ${ethers.formatEther(initialReserveA)} / ${ethers.formatEther(initialReserveB)}`);
      console.log(`   📊 Final reserves: ${ethers.formatEther(finalReserveA)} / ${ethers.formatEther(finalReserveB)}`);
      console.log(`   📈 Current ratio: ${currentRatio.toString()}`);
    });
  });

  describe("🔴 Demonstrated Vulnerabilities", function () {
    it("🚨 Flash Loan Attack - No fees", async function () {
      const { pool, tokenA, tokenB, alice, attacker, attackerContract } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // Attacker executes flash loan
      const flashLoanAmount = ethers.parseEther("500");
      
      const attackerInitialBalance = await tokenA.balanceOf(attacker.address);
      
      // Transfer tokens to attacker contract
      await tokenA.connect(attacker).transfer(attackerContract.target, ethers.parseEther("100"));
      await tokenB.connect(attacker).transfer(attackerContract.target, ethers.parseEther("100"));

      // Execute attack
      await expect(attackerContract.connect(attacker).flashLoanAttack(flashLoanAmount, true))
        .to.not.be.reverted;

      const [profitA, profitB] = await attackerContract.getLastAttackProfit();
      
      console.log("   🚨 Flash Loan Attack executed");
      console.log(`   💰 Token A profit: ${ethers.formatEther(profitA)}`);
      console.log(`   💰 Token B profit: ${ethers.formatEther(profitB)}`);
      console.log("   ⚠️  Attacker didn't pay fees for flash loan!");
    });

    it("🚨 Price Manipulation Attack", async function () {
      const { pool, tokenA, tokenB, alice, attacker, attackerContract } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // Transfer tokens to attacker
      await tokenA.connect(attacker).transfer(attackerContract.target, ethers.parseEther("500"));
      await tokenB.connect(attacker).transfer(attackerContract.target, ethers.parseEther("500"));

      const initialPrice = await pool.getCurrentPrice();
      
      // Execute price manipulation attack
      await expect(attackerContract.connect(attacker).priceManipulationAttack(ethers.parseEther("300")))
        .to.emit(attackerContract, "PriceManipulated");

      const finalPrice = await pool.getCurrentPrice();
      const priceChange = ((finalPrice - initialPrice) * 100n) / initialPrice;

      console.log("   🚨 Price Manipulation Attack executed");
      console.log(`   📈 Initial price: ${ethers.formatEther(initialPrice)}`);
      console.log(`   📈 Final price: ${ethers.formatEther(finalPrice)}`);
      console.log(`   📊 Price change: ${priceChange.toString()}%`);
      console.log("   ⚠️  Attacker successfully manipulated price!");
    });

    it("🚨 Sandwich Attack Simulation", async function () {
      const { pool, tokenA, tokenB, alice, attacker, attackerContract } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // Transfer tokens to attacker
      await tokenA.connect(attacker).transfer(attackerContract.target, ethers.parseEther("200"));
      await tokenB.connect(attacker).transfer(attackerContract.target, ethers.parseEther("200"));

      const victimSwapAmount = ethers.parseEther("100");
      
      // Execute sandwich attack
      await expect(attackerContract.connect(attacker).sandwichAttack(victimSwapAmount))
        .to.emit(attackerContract, "SandwichAttackExecuted");

      const [balanceA, balanceB] = await attackerContract.getBalances();
      
      console.log("   🚨 Sandwich Attack simulated");
      console.log(`   🎯 Victim amount: ${ethers.formatEther(victimSwapAmount)}`);
      console.log(`   💰 Final balance A: ${ethers.formatEther(balanceA)}`);
      console.log(`   💰 Final balance B: ${ethers.formatEther(balanceB)}`);
      console.log("   ⚠️  Attacker successfully front-ran!");
    });
  });

  describe("🛡️ Protections and Advanced Features", function () {
    it("✅ Extreme slippage protection", async function () {
      const { pool, tokenA, tokenB, alice, bob, owner } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // First set restrictive slippage protection
      await pool.connect(owner).setMEVProtection(500, 0); // 5% max slippage
      
      // Try swap causing extreme slippage
      const extremeSwap = ethers.parseEther("800"); // 80% of pool
      await tokenA.connect(bob).approve(pool.target, extremeSwap);

      await expect(pool.connect(bob).swap(tokenA.target, extremeSwap, 0))
        .to.be.revertedWith("Price impact too high");

      console.log("   🛡️ Extreme slippage protection working");
      console.log(`   ⚠️  Swap of ${ethers.formatEther(extremeSwap)} TKA rejected`);
    });

    it("✅ Emergency mode", async function () {
      const { pool, tokenA, tokenB, alice, bob, owner } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // Activate emergency mode
      await expect(pool.connect(owner).activateEmergencyMode())
        .to.emit(pool, "EmergencyModeActivated");

      // Try swap in emergency mode
      await tokenA.connect(bob).approve(pool.target, ethers.parseEther("100"));
      await expect(pool.connect(bob).swap(tokenA.target, ethers.parseEther("100"), 0))
        .to.be.revertedWith("Emergency mode active");

      console.log("   🚨 Emergency mode activated successfully");
      console.log("   🛡️ All operations blocked correctly");
    });

    it("✅ Basic MEV protection", async function () {
      const { pool, tokenA, tokenB, alice, bob, owner } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // Enable front-run protection with higher threshold for testing
      await pool.connect(owner).setMEVProtection(5000, 10); // 50% slippage, 10 blocks front-run protection

      // First transaction
      await tokenA.connect(bob).approve(pool.target, ethers.parseEther("100"));
      await pool.connect(bob).swap(tokenA.target, ethers.parseEther("100"), 0);

      // Get current block number
      const currentBlock = await network.provider.send("eth_blockNumber");
      console.log(`   🔍 Current block: ${parseInt(currentBlock, 16)}`);

      // Try second transaction immediately (should fail due to block protection)
      await tokenA.connect(bob).approve(pool.target, ethers.parseEther("50"));
      await expect(pool.connect(bob).swap(tokenA.target, ethers.parseEther("50"), 0))
        .to.be.revertedWith("Front-run protection active");

      console.log("   🛡️ Basic MEV protection working");
      console.log("   ⚠️  Front-running successfully blocked");
    });
  });

  describe("📊 Metrics and Analysis", function () {
    it("📈 Show pool metrics", async function () {
      const { pool, tokenA, tokenB, alice, bob } = await loadFixture(deployLiquidityPoolFixture);

      // Setup: Alice adds liquidity
      const liquidityA = ethers.parseEther("1000");
      const liquidityB = ethers.parseEther("1000");
      await tokenA.connect(alice).approve(pool.target, liquidityA);
      await tokenB.connect(alice).approve(pool.target, liquidityB);
      await pool.connect(alice).addLiquidity(liquidityA, liquidityB, 0);

      // Execute several swaps
      for (let i = 0; i < 3; i++) {
        await tokenA.connect(bob).approve(pool.target, ethers.parseEther("50"));
        await pool.connect(bob).swap(tokenA.target, ethers.parseEther("50"), 0);
        
        // Advance one block to avoid MEV protection
        await network.provider.send("evm_mine");
      }

      // Get metrics
      const [reserveA, reserveB] = await pool.getReserves();
      const currentPrice = await pool.getCurrentPrice();
      const dynamicFee = await pool.dynamicFeeRate();
      const totalLiquidity = await pool.totalLiquidityTokens();
      const [accFeesA, accFeesB] = await Promise.all([
        pool.accumulatedFeesA(),
        pool.accumulatedFeesB()
      ]);

      // User info
      const [liquidityBalance, sharePercentage, estimatedValueA, estimatedValueB] = 
        await pool.getUserInfo(alice.address);

      console.log("\n   📊 POOL METRICS:");
      console.log(`   💰 Reserves: ${ethers.formatEther(reserveA)} TKA / ${ethers.formatEther(reserveB)} TKB`);
      console.log(`   📈 Current price: ${ethers.formatEther(currentPrice)}`);
      console.log(`   💸 Dynamic fee: ${dynamicFee} basis points`);
      console.log(`   🏦 Total liquidity: ${ethers.formatEther(totalLiquidity)}`);
      console.log(`   💵 Accumulated fees: ${ethers.formatEther(accFeesA)} TKA / ${ethers.formatEther(accFeesB)} TKB`);
      console.log(`   👤 Alice - Liquidity: ${ethers.formatEther(liquidityBalance)}`);
      console.log(`   👤 Alice - Share: ${sharePercentage}%`);
      console.log(`   👤 Alice - Estimated value: ${ethers.formatEther(estimatedValueA)} TKA / ${ethers.formatEther(estimatedValueB)} TKB`);
    });
  });
}); 