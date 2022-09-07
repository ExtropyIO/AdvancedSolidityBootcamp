const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Types_2 contract", async function() {
  beforeEach(async function() {
    Types2 = await ethers.getContractFactory("Types_1");
    types2 = await Types2.deploy();
  });
});
