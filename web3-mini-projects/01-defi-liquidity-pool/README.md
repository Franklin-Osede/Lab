# 🏦 DeFi Liquidity Pool - Advanced Educational Project

[![Solidity](https://img.shields.io/badge/Solidity-^0.8.24-blue.svg)](#)
[![Hardhat](https://img.shields.io/badge/Hardhat-2.19.0-yellow.svg)](#)
[![Foundry](https://img.shields.io/badge/Foundry-1.2.3-red.svg)](#)
[![Tests](https://img.shields.io/badge/Tests-19_passing-green.svg)](#tests)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](#license)

> **⚠️ WARNING:** This project is **EDUCATIONAL ONLY**. The contracts contain intentional vulnerabilities to demonstrate security concepts. **DO NOT use in production**.

## 📋 Project Description

This project implements an **advanced DeFi Liquidity Pool** with professional features and educational vulnerabilities. It includes exhaustive testing with **Hardhat** and **Foundry**, demonstrating blockchain development best practices.

### 🎯 Main Features

- ✅ **AMM (Automated Market Maker)** with `x * y = k` formula
- ✅ **Dynamic fees** (0.1% - 1%) based on volatility
- ✅ **Automatic rebalancing** every 1 hour
- ✅ **MEV protections** configurable
- ✅ **Flash loans** (with educational vulnerabilities)
- ✅ **Emergency mode** to pause operations
- ✅ **Exhaustive testing** (19 tests total)

---

## 🏗️ Project Structure

```
web3-mini-projects/01-defi-liquidity-pool/
├── 📁 contracts/                           # Main contracts
│   ├── 🏦 DeFiLiquidityPool.sol           # Main contract 
│   ├── 📁 interfaces/
│   │   └── 🔗 ILiquidityPool.sol          # Standard interface 
│   ├── 📁 libraries/
│   │   └── 🧮 LiquidityMath.sol           # Math library (272 lines)
│   └── 📁 mocks/
│       ├── 🔓 MockERC20.sol               # Test token (105 lines)
│       └── 🎯 MockAttacker.sol            # Attacker contract (246 lines)
├── 📁 test/                               # Tests
│   ├── 🔍 DeFiLiquidityPool.basic.test.js # Hardhat tests (368 lines)
│   └── ⚡ DeFiLiquidityPool.t.sol         # Foundry tests (212 lines)
├── 📁 scripts/                            # Demo scripts
│   └── 🎬 demo-setup.js                   # Demo configuration
├── ⚙️ hardhat.config.js                  # Hardhat configuration
├── ⚙️ foundry.toml                       # Foundry configuration
├── 📦 package.json                       # Dependencies and scripts
└── 📖 README.md                          # This documentation
```

---

## 🔧 Component Explanation

### 🏦 1. **DeFiLiquidityPool.sol** - Main Contract

**Functionalities:**
- **Liquidity management:** `addLiquidity()`, `removeLiquidity()`
- **Swaps:** `swap()` with dynamic fees
- **Rebalancing:** Automatic based on thresholds
- **Flash loans:** `flashLoan()` (vulnerable for education)
- **Protections:** MEV, slippage, emergency

**Technical characteristics:**
```solidity
- AMM Formula: x * y = k
- Dynamic fees: 0.1% - 1%
- Slippage protection: 20% (configurable)
- Rebalancing: every 1 hour
- MEV protection: blocks between transactions
```

### 🧮 2. **LiquidityMath.sol** - Math Library

**Main functions:**
- `getAmountOut()` - Output calculation for swaps
- `calculatePriceImpact()` - Price impact calculation
- `calculateImpermanentLoss()` - Impermanent loss calculation
- `sqrt()` - Square root (Babylonian method)
- `calculateOptimalLiquidity()` - Optimal liquidity calculation

### 🔗 3. **ILiquidityPool.sol** - Standard Interface

Defines the standard contract with:
- 📝 Main events
- 🔧 Liquidity functions
- 🔄 Swap functions
- 👀 Query functions
- 🛡️ Administrative functions

### 🔓 4. **MockERC20.sol** - Test Token

Simulates real tokens (USDC/USDT) with special functions:
- `mint()` - Create tokens
- `burn()` - Destroy tokens
- `setBalance()` - Configure balance
- `setTransfersShouldFail()` - Simulate errors

### 🎯 5. **MockAttacker.sol** - Educational Attacker Contract

**⚠️ EDUCATIONAL ONLY - Implements attacks:**
- 🚨 **Flash Loan Attack** (without fees)
- 📈 **Price Manipulation Attack**
- 🥪 **Sandwich Attack**
- ⚖️ **Rebalance Manipulation**

---

## 🧪 Tests - Complete Coverage

### 📊 **Hardhat Tests** (10 JavaScript tests)

```javascript
✅ Basic functionalities:
   - Add liquidity
   - Swaps with dynamic fees
   - Automatic rebalancing

✅ Demonstrated vulnerabilities:
   - Flash loan attack
   - Price manipulation
   - Sandwich attack

✅ Protections:
   - Extreme slippage protection
   - Emergency mode
   - MEV protection

✅ Metrics:
   - Pool metrics analysis
```

### ⚡ **Foundry Tests** (9 Solidity tests)

```solidity
✅ Basic tests:
   - testAddLiquidity()
   - testSwap()
   - testCurrentPrice()

✅ Fuzzing tests:
   - testFuzzAddLiquidity() (10,000 runs)
   - testFuzzSwap() (10,000 runs)

✅ Protection tests:
   - testSlippageProtection()
   - testEmergencyMode()

✅ Invariant tests:
   - invariant_ConstantProduct()
```

---

## 🚀 Installation and Setup

### Prerequisites
- Node.js >= 18.0.0
- npm or yarn
- Git

### 1. Clone and install dependencies
```bash
git clone <repository-url>
cd web3-mini-projects/01-defi-liquidity-pool
npm install
```

### 2. Install Foundry (optional)
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
forge install foundry-rs/forge-std
```

---

## 🎮 Available Commands

### 🔧 **Hardhat Commands**

```bash
# Testing
npm run test              # Run all tests (10 tests)
npm run test:gas          # Tests with gas reporting
npm run test:coverage     # Tests with code coverage

# Compilation
npm run compile           # Compile contracts

# Deployment
npm run deploy:local      # Deploy to local network
npm run deploy:mainnet-fork # Deploy to mainnet fork
npm run start:node        # Start local node

# Demos
npm run demo:setup        # Setup demo
npm run demo:basic        # Basic demo
npm run demo:attack       # Attack demo
npm run demo:protection   # Protection demo

# Analysis
npm run analyze           # Static analysis with Slither
```

### ⚡ **Foundry Commands**

```bash
# Testing
npm run test:fuzz         # Fuzzing tests (10,000 runs)
npm run test:invariant    # Invariant tests
forge test                # Run all tests
forge test -vv            # Tests with verbosity
forge test --match-test testSwap # Specific test

# Compilation
forge build               # Compile contracts
forge clean               # Clean artifacts

# Analysis
forge coverage            # Coverage report
forge fmt                 # Format code
forge snapshot            # Gas snapshot
```

---

## 🎬 Video Demo Guide

### 🎯 **1. Introduction (2-3 min)**
```
"Complete DeFi project including:
- ✅ Liquidity Pool with AMM
- ✅ Exhaustive tests (Hardhat + Foundry)
- ✅ Educational vulnerabilities
- ✅ Advanced MEV protections"
```

### 🏗️ **2. Architecture (3-4 min)**
```bash
# Show structure
tree contracts/
ls -la test/

# Show lines of code
wc -l contracts/*.sol
```

### 💻 **3. Practical Demonstration (8-10 min)**
```bash
# Hardhat tests
npm run test              # 10 passing tests
npm run test:gas          # Gas reports

# Foundry tests
forge test -vv            # 9 passing tests
npm run test:fuzz         # Advanced fuzzing

# Coverage
npm run test:coverage     # Complete analysis
```

### 🚨 **4. Educational Vulnerabilities (3-4 min)**
```
Explain each attack:
- 🔓 Flash loans without fees
- 📈 Price manipulation
- 🥪 Sandwich attacks
- ⚖️ Rebalance manipulation
```

### 🛡️ **5. Protections (2-3 min)**
```
Show implemented protections:
- 🔒 MEV protection
- 📊 Slippage limits
- 🚨 Emergency mode
- ⚖️ Automatic rebalancing
```

### 🎯 **6. Conclusions (1-2 min)**
```
"Complete demonstration of:
- ✅ Professional DeFi development
- ✅ Exhaustive testing
- ✅ Security considerations"
```

---

## 📊 Project Metrics

| Metric | Value |
|---------|-------|
| **Solidity Contracts** | 5 files |
| **Lines of code** | ~1,100 lines |
| **Total tests** | 19 tests |
| **Hardhat tests** | 10 JavaScript tests |
| **Foundry tests** | 9 Solidity tests |
| **Fuzzing runs** | 10,000 per test |
| **Coverage** | High coverage |
| **Frameworks** | Hardhat + Foundry |

---

## 🔒 Educational Vulnerabilities

### ⚠️ **IMPORTANT WARNING**
The following vulnerabilities are implemented **FOR EDUCATIONAL PURPOSES ONLY**:

1. **Flash Loan without fees** - Allows free loans
2. **Price manipulation** - Pool price manipulation
3. **Sandwich attacks** - Transaction front-running
4. **Rebalance manipulation** - Rebalancing exploitation

### 🛡️ **Implemented Protections**

1. **MEV Protection** - Blocks between transactions
2. **Slippage Protection** - Price impact limits
3. **Emergency Mode** - Pause operations in emergency
4. **Automatic Rebalancing** - Maintain pool balance

---

## 🤝 Contributions

This project is educational. Contributions are welcome for:
- 📖 Improving documentation
- 🧪 Adding more tests
- 🔒 Implementing more protections
- 📚 Adding more educational vulnerabilities

---

## 📜 License

This project is under MIT license. See LICENSE for more details.

---

## 📞 Contact

For questions about this educational project:
- 📧 Email: your-email@example.com
- 💬 GitHub: @your-username
- 🐦 Twitter: @your-username

---

## 🙏 Acknowledgments

- OpenZeppelin for base contracts
- Hardhat for development framework
- Foundry for testing tools
- DeFi community for education and best practices

---

**⚠️ REMINDER:** This project is educational only. Vulnerabilities are included to demonstrate security concepts. **DO NOT use in production without appropriate fixes.** 