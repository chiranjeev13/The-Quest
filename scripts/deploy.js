const hre = require("hardhat");

async function main() {
  const pharmaChain = await hre.ethers.getContractFactory(
    "pharmaceutical_management"
  );
  const pcDeployed = await pharmaChain.deploy();

  console.log((await pcDeployed.deployed()).address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
