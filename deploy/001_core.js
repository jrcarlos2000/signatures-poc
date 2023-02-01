require("hardhat");
const { utils } = require("ethers");
const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { parseUnits, formatUnits } = require("ethers").utils;
const { getTokenAddresses, isFork } = require("../utils/helpers");
const {
  deployWithConfirmation,
  withConfirmation,
  log,
} = require("../utils/deploy");

const deploySignatureTester = async () => {
  await deployWithConfirmation("SignatureTester");
};

const main = async () => {
  await deploySignatureTester();
};

main.id = "001_core";
main.skip = () => false;
module.exports = main;
