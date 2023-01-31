const { expect } = require("chai");
const { ethers } = require("hardhat");
const { defaultFixture } = require("./_fixture");
const { loadFixture } = require("../utils/helpers");
const { parseUnits, formatBytes32String } = require("ethers/lib/utils");
const { BigNumber } = require("ethers");
const { getTxOpts } = require("../utils/tx");

describe("Singature Tester", async () => {
  describe("Trial 1", async () => {
    it("check function  gas cost", async () => {
      const { cSignatureTester, bob } = await loadFixture(defaultFixture);
      const messageDigest =
        "0x" +
        ethers.utils.solidityKeccak256(
          [
            "address",
            "uint256",
            "uint256",
            "uint256",
            "address",
            "address",
            "address",
          ],
          [
            ethers.constants.AddressZero,
            "12",
            "12",
            "12",
            ethers.constants.AddressZero,
            ethers.constants.AddressZero,
            ethers.constants.AddressZero,
          ]
        );
      // console.log("done here");
      // let messageHashBytes = ethers.utils.arrayify(messageDigest);
      // console.log("done here");
      const signature = bob.signMessage(messageDigest);
      const _data = ethers.utils.defaultAbiCoder.encode(
        ["address", "uint256", "uint256", "uint256", "bytes"],
        [
          ethers.constants.AddressZero,
          120000,
          120000,
          120000,
          formatBytes32String(signature),
        ]
      );
      const tx = await cSignatureTester.verifyTransfer(
        ethers.constants.AddressZero,
        ethers.constants.AddressZero,
        120000,
        _data
      );
      console.log(tx);
      await tx.wait();
    });
  });
});
