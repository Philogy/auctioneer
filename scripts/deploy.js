const { ethers } = require('hardhat')

async function main() {
  const TestData = await ethers.getContractFactory('TestData')
  const testData = await TestData.deploy()
  console.log(`deployed to: ${testData.address}`)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error('err:', err)
    process.exit(1)
  })
