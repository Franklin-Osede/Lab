# 🚀 Advanced DeFi Liquidity Pool

A sophisticated DeFi liquidity pool with advanced features designed to demonstrate professional-level testing with **Hardhat** and **Foundry**. Perfect for educational content and Web3 development demonstrations.

## 🎯 Key Features

### 💡 Advanced Functionalities
- **Automatic Rebalancing**: Pool automatically rebalances based on configurable thresholds
- **Dynamic Fees**: Commissions adjust based on market volatility
- **MEV Protection**: Basic protection mechanism against front-running
- **Flash Loans**: Implementation of instant loans (with controlled vulnerability)
- **Emergency Mode**: Security controls to pause operations

### 🔧 Technical Features
- **Dual Testing**: Configured for both Hardhat and Foundry
- **Advanced Fuzzing**: Tests with fuzzing to find edge cases
- **Invariant Testing**: Verification of mathematical properties
- **Gas Optimization**: Gas analysis and optimization
- **Controlled Vulnerabilities**: For educational security demos

## 🛠️ Installation and Setup

### Prerequisites
- Node.js >= 18.0.0
- npm or yarn
- Foundry (optional, for advanced testing)

### Installation Commands

```bash
# Navigate to project directory
cd web3-mini-projects/01-defi-liquidity-pool

# Install dependencies
npm install

# Install Foundry dependencies (if using Foundry)
forge install

# Compile contracts
npm run compile

# Run basic tests
npm test
```

### Environment Configuration
Create a `.env` file:
```env
# RPC URLs
MAINNET_RPC_URL=https://eth-mainnet.alchemyapi.io/v2/your-api-key
POLYGON_RPC_URL=https://polygon-mainnet.alchemyapi.io/v2/your-api-key

# API Keys
ETHERSCAN_API_KEY=your-etherscan-api-key
POLYGONSCAN_API_KEY=your-polygonscan-api-key
COINMARKETCAP_API_KEY=your-coinmarketcap-api-key

# Testing
REPORT_GAS=true
```

## 🧪 Advanced Testing

### Hardhat Tests
```bash
# Basic tests
npm test

# Tests with gas report
npm run test:gas

# Complete coverage
npm run test:coverage

# Tests on mainnet fork
npm run deploy:mainnet-fork
```

### Foundry Tests
```bash
# Intensive fuzzing
npm run test:fuzz

# Invariant testing
npm run test:invariant

# Tests with different profiles
forge test --profile dev    # Fast development
forge test --profile ci     # Complete CI/CD
```

## 🎥 Demo Scripts for Videos

### 1. Basic Demo - Core Functionalities
```bash
npm run demo:setup
```
**What it shows:**
- Create liquidity pool
- Add liquidity
- Execute swaps
- Show dynamic fees
- Automatic rebalancing

### 2. Vulnerabilities Demo
```bash
npm run demo:attack
```
**What it shows:**
- Flash loan without fees
- Price manipulation
- Basic front-running
- Rebalancing exploits

### 3. Protections Demo
```bash
npm run demo:protection
```
**What it shows:**
- MEV protection activated
- Slippage limits
- Emergency mode
- Admin controls

## 📊 Analysis and Metrics

### Code Analysis
```bash
# Static analysis with Slither
npm run analyze

# Optimized gas report
REPORT_GAS=true npm test
```

### Pool Metrics
```bash
# Start local node
npm run start:node

# In another terminal, execute metrics
node scripts/metrics.js
```

## 🔍 Use Cases for Videos

### Video 1: "Creating a Professional DeFi Pool"
- Show contract architecture
- Explain AMM mathematics
- Demonstrate advanced features
- **Duration**: 15-20 minutes

### Video 2: "Advanced Testing with Fuzzing"
- Configure fuzzing with Foundry
- Find bugs with property testing
- Invariant analysis
- **Duration**: 12-15 minutes

### Video 3: "DeFi Vulnerabilities and Attacks"
- Demonstrate flash loan attacks
- Show price manipulation
- Implement protections
- **Duration**: 18-22 minutes

### Video 4: "Gas Optimization and Performance"
- Gas analysis with Hardhat
- Storage optimizations
- Benchmarking with Foundry
- **Duration**: 10-12 minutes

## 🚨 Educational Vulnerabilities

### 1. Flash Loan Without Fees
**Location**: `flashLoan()` function
**Problem**: Doesn't charge fees for instant loans
**Exploitation**: Free arbitrage

### 2. Manipulable Rebalancing
**Location**: `_executeRebalance()` function
**Problem**: Simplified rebalancing logic
**Exploitation**: Price manipulation

### 3. Oracle Price Dependency
**Location**: `updateOraclePrice()` function
**Problem**: Depends on single oracle
**Exploitation**: Price manipulation

## 🏗️ Project Architecture

```
contracts/
├── DeFiLiquidityPool.sol      # Main contract
├── interfaces/
│   └── ILiquidityPool.sol     # Main interface
├── libraries/
│   └── LiquidityMath.sol      # Mathematical library
├── mocks/
│   ├── MockERC20.sol          # Test token
│   └── MockAttacker.sol       # Attacker for demos
└── test/
    ├── unit/                  # Unit tests
    ├── integration/           # Integration tests
    ├── fuzz/                  # Fuzzing tests
    └── invariant/             # Invariant tests
```

## 📋 File-by-File Explanation

### Core Contracts

#### `DeFiLiquidityPool.sol` (Main Contract)
**Purpose**: Core liquidity pool with advanced features
**Key Features**:
- Automatic rebalancing based on price ratios
- Dynamic fees that adjust with volatility
- MEV protection through block-based delays
- Flash loans with controlled vulnerabilities
- Emergency controls and pausable functionality

**Why Important**: Demonstrates production-quality DeFi contract architecture with real-world features and controlled vulnerabilities for educational purposes.

#### `ILiquidityPool.sol` (Interface)
**Purpose**: Standard interface for the liquidity pool
**Key Features**:
- Complete function signatures
- Event definitions
- Documentation for all public functions

**Why Important**: Following interface standards is crucial for DeFi interoperability and testing.

#### `LiquidityMath.sol` (Library)
**Purpose**: Mathematical calculations for AMM operations
**Key Features**:
- AMM formula implementations (x * y = k)
- Price impact calculations
- Slippage calculations
- Impermanent loss calculations
- Square root function (Babylonian method)

**Why Important**: Shows advanced mathematical concepts in DeFi and gas-efficient implementations.

### Testing Infrastructure

#### `MockERC20.sol` (Test Token)
**Purpose**: ERC20 token for testing with additional features
**Key Features**:
- Mintable tokens for test scenarios
- Configurable decimals
- Ability to simulate transfer failures
- Balance manipulation for testing

**Why Important**: Essential for comprehensive testing scenarios and edge cases.

#### `MockAttacker.sol` (Educational Attacker)
**Purpose**: Demonstrates common DeFi attack vectors
**Key Features**:
- Flash loan attacks
- Price manipulation
- Sandwich attacks
- Rebalance exploitation

**Why Important**: Educational tool to understand DeFi security vulnerabilities.

#### `DeFiLiquidityPool.basic.test.js` (Test Suite)
**Purpose**: Comprehensive test suite
**Key Features**:
- Basic functionality tests
- Attack simulations
- Protection verifications
- Metrics and analytics

**Why Important**: Demonstrates professional testing practices in DeFi.

### Configuration Files

#### `package.json`
**Purpose**: Project configuration and dependencies
**Key Features**:
- All necessary Hardhat dependencies
- Testing scripts
- Demo scripts
- Gas reporting tools

#### `hardhat.config.js`
**Purpose**: Hardhat configuration
**Key Features**:
- Network configurations
- Forking setup
- Gas reporting
- Optimization settings

#### `foundry.toml`
**Purpose**: Foundry configuration
**Key Features**:
- Fuzzing configurations
- Invariant testing setup
- Different testing profiles
- Gas optimization

### Demo Scripts

#### `demo-setup.js`
**Purpose**: Setup script for video demonstrations
**Key Features**:
- Automated contract deployment
- Token distribution
- Initial pool configuration
- Demo instructions

**Why Important**: Streamlines the process of creating educational content.

## 🎛️ Advanced Configuration

### Hardhat Custom Tasks
```bash
# Deploy with custom configuration
npx hardhat deploy --network localhost --fee-rate 50

# Simulate attacks
npx hardhat attack --type flashloan --amount 1000
```

### Foundry Profiles
```toml
[profile.dev]
fuzz = { runs = 1000 }
invariant = { runs = 100 }

[profile.ci]
fuzz = { runs = 10000 }
invariant = { runs = 1000 }
```

## 📈 Performance Metrics

### Gas Consumption
- **Add Liquidity**: ~95,000 gas
- **Remove Liquidity**: ~75,000 gas
- **Swap**: ~65,000 gas
- **Flash Loan**: ~45,000 gas

### Test Coverage
- **Statements**: 95%+
- **Branches**: 90%+
- **Functions**: 100%
- **Lines**: 95%+

## 🔗 Additional Resources

### Documentation
- [Hardhat Documentation](https://hardhat.org/docs)
- [Foundry Book](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts)

### Tools Used
- **Hardhat**: Development framework
- **Foundry**: Advanced testing and fuzzing
- **Slither**: Static analysis
- **Solhint**: Solidity linting
- **Hardhat Gas Reporter**: Gas analysis

## 🤝 Contributions

This project is designed to be educational. If you find real bugs or improvements, contributions are welcome.

## ⚠️ Disclaimer

This code is **FOR EDUCATIONAL PURPOSES ONLY**. It contains intentional vulnerabilities to demonstrate security concepts. **DO NOT use in production**.

---

**Perfect for creating educational content about DeFi, Advanced Testing, and Web3 Security!** 🚀

## 📋 Quick Start Checklist

1. ✅ **Install dependencies**: `npm install`
2. ✅ **Compile contracts**: `npm run compile`
3. ✅ **Run tests**: `npm test`
4. ✅ **Setup demo**: `npm run demo:setup`
5. ✅ **Create first video**: Start with basic functionalities
6. ✅ **Analyze with Slither**: `npm run analyze`
7. ✅ **Test with fuzzing**: `npm run test:fuzz` 