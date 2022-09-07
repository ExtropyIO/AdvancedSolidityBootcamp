const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Types_4 contract", async function() {
  beforeEach(async function() {
    [addr1, addr2, addr3] = await ethers.getSigners();
    Types4 = await ethers.getContractFactory("Types_4");
  });

  it("Deployer can set any address as admin", async function() {
    types4 = await Types4.deploy(addr2.address);
    expect(await types4.admin()).to.equal(addr2.address);
  });

  it("Any address can't update admin", async function() {
    let types4_2;
    try {
      types4_2 = await Types4.deploy(addr2.address);
    } catch {
      types4_2 = await Types4.connect(addr2).deploy();
    }

    try {
      await types4_2.connect(addr1).changeAdmin(addr3.address);
    } catch {}
    expect(await types4_2.admin()).to.equal(addr2.address);
  });
});

// TODO: Ensure tests work on test
