const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Types_1 contract", async function() {
  beforeEach(async function() {
    Types1 = await ethers.getContractFactory("Types_1");
    types1 = await Types1.deploy();
  });

  it("tisTrue name is accurate", async function() {
    expect(await types1.getTisTrue()).to.equal(true);
  });

  it("setSolBool updates solBool", async function() {
    expect(await types1.getSolBool()).to.equal(false);
    await types1.setSolBool(true);
    expect(await types1.getSolBool()).to.equal(true);
  });
});
