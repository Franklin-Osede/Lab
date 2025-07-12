require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  networks: {
    hardhat: {
      chainId: 31337,
      forking: {
        url: process.env.MAINNET_RPC_URL || "https://eth-mainnet.alchemyapi.io/v2/your-api-key",
        enabled: false, // Enable when you need forking
      },
      mining: {
        auto: true,
        interval: 0,
      },
    },
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
    },
    "mainnet-fork": {
      url: "http://127.0.0.1:8545",
      chainId: 1,
      forking: {
        url: process.env.MAINNET_RPC_URL || "https://eth-mainnet.alchemyapi.io/v2/your-api-key",
        blockNumber: 18500000, // Specific block for reproducible tests
      },
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    gasPrice: 30, // gwei
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
    outputFile: "gas-report.txt",
    noColors: true,
  },
  mocha: {
    timeout: 60000, // 60 seconds for complex tests
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
}; 