const { expect } = require("chai");
const { ethers } = require("hardhat");
const { defaultFixture } = require("./_fixture");
const { loadFixture } = require("../utils/helpers");
const { parseUnits, formatBytes32String } = require("ethers/lib/utils");
const { BigNumber } = require("ethers");
const { getTxOpts } = require("../utils/tx");
const abi = require("ethereumjs-abi");

describe("Singature Tester", async () => {
  describe("Trial 1", async () => {
    let cSignatureTester;
    let bob, tay;
    let transferAmount;

    before(async () => {
      const fixture = await loadFixture(defaultFixture);
      cSignatureTester = fixture.cSignatureTester;
      bob = fixture.bob;
      tay = fixture.tay;
      transferAmount = 100;
      console.log(bob.address)
    });

    // function returns the data for the call of contract
    async function performVerifyTransfer(sigTypes, sigParams) {
      const messageDigest = abi
        .soliditySHA3(sigTypes, sigParams)
        .toString("hex");
      // const signature = await bob.signMessage(messageDigest);
      const signature = await bob.signMessage(
        ethers.utils.arrayify(
          ethers.utils.keccak256(
            ethers.utils.defaultAbiCoder.encode(sigTypes, sigParams)
          )
        )
      );
      const data = ethers.utils.defaultAbiCoder.encode(
        [...sigTypes.slice(0, sigTypes.length - 3), "bytes"],
        [...sigParams.slice(0, sigParams.length - 3), signature]
      );
      return [...sigParams.slice(-3), data];
    }
    it("function 1", async () => {
      const params = await performVerifyTransfer(
        [
          "address",
          "uint256",
          "uint256",
          "uint256",
          "address",
          "address",
          "uint256",
        ],
        [
          cSignatureTester.address,
          1,
          12,
          100000000000,
          bob.address,
          tay.address,
          transferAmount,
        ]
      );
      const tx = await cSignatureTester.connect(bob).verifyTransfer1(...params);
      await tx.wait();
      // console.log(tx, bob.address);
    });
    it("function 2", async () => {
      const params = await performVerifyTransfer(
        [
          "address",
          "uint256",
          "uint256",
          "uint256",
          "uint256",
          "address",
          "address",
          "uint256",
        ],
        [
          cSignatureTester.address,
          1,
          12,
          100000000000,
          100,
          bob.address,
          tay.address,
          transferAmount,
        ]
      );
      const tx = await cSignatureTester.connect(bob).verifyTransfer2(...params);
      await tx.wait();
    });
    it("function 3", async () => {
      const params = await performVerifyTransfer(
        [
          "address",
          "uint256",
          "uint256",
          "uint256",
          "uint256",
          "uint256",
          "address",
          "address",
          "uint256",
        ],
        [
          cSignatureTester.address,
          1,
          12,
          100000000000,
          100,
          100,
          bob.address,
          tay.address,
          transferAmount,
        ]
      );
      const tx = await cSignatureTester.connect(bob).verifyTransfer3(...params);
      await tx.wait();
    });
    it("function 4", async () => {
      const params = await performVerifyTransfer(
        [
          "address",
          "uint256",
          "uint256",
          "uint256",
          "uint256",
          "uint256",
          "uint256",
          "address",
          "address",
          "uint256",
        ],
        [
          cSignatureTester.address,
          1,
          12,
          100000000000,
          100,
          100,
          100,
          bob.address,
          tay.address,
          transferAmount,
        ]
      );
      const tx = await cSignatureTester.connect(bob).verifyTransfer4(...params);
      await tx.wait();
    });
  });
});
