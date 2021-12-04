require('dotenv').config()
require('@nomiclabs/hardhat-ethers')
/**
 * @type import('hardhat/config').HardhatUserConfig
 */

const accounts = process.env.PRIV_KEY !== undefined ? [process.env.PRIV_KEY] : []

module.exports = {
  solidity: {
    version: '0.8.10',
    optimizer: {
      enabled: true,
      runs: 10_000
    }
  },
  networks: {
    rinkeby: {
      url: 'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161', // public metamask url
      accounts
    }
  }
}
