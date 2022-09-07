const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Scope", async function() {
  console.log("testin");
  it("Scope conract deploys", async function() {
    const SubOverflow = await ethers.getContractFactory("Scope");
    const subOverflow = await SubOverflow.deploy();
  });

  it("Subtracts", async function() {
    const SubOverflow = await ethers.getContractFactory("Scope");
    const subOverflow = await SubOverflow.deploy();
    await subOverflow.increment(66);
    expect(await subOverflow.count()).to.equal(76);
  });
});
