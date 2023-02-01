const { ethers } = require("hardhat");
const hre = require("hardhat");

async function defaultFixture() {
  await deployments.fixture();
  const cSignatureTester = await ethers.getContract("SignatureTester");
  const signers = await ethers.getSigners();
  const bob = signers[0];
  const tay = signers[1];
  return {
    bob,
    tay,
    cSignatureTester,
  };
}

module.exports = {
  defaultFixture,
};
