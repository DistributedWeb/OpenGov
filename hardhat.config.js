require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");


const { privateKey, projectId, apiKey } = require('./secrets.json');

module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      chainId: 1337
    },
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    polygon: {
      url: `https://rpc-mainnet.maticvigil.com/v1/${projectId}`,
      accounts: [privateKey],
      gasPrice: 20000000000
    },
    polygon-fork: {
      url: `https://rpc-mainnet.maticvigil.com/v1/${projectId}`,
      accounts: [privateKey],
      gasPrice: 20000000000,
      forking: {
        url: `https://rpc-mainnet.maticvigil.com/v1/${projectId}`,
      }
    },
  },
  etherscan: {
    apiKey: apiKey
  }
};


