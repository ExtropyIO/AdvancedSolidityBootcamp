const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Subtract", async function() {
  console.log("testin");
  it("Conract deploys", async function() {
    const SubOverflow = await ethers.getContractFactory("SubOverflow");
    const subOverflow = await SubOverflow.deploy();
  });

  it("Subtracts", async function() {
    const SubOverflow = await ethers.getContractFactory("SubOverflow");
    const subOverflow = await SubOverflow.deploy();
    let resultAssembly = parseInt(await subOverflow.subtract(4, 3));
    assert.equal(resultAssembly, 1);
  });

  it("Doesn't overflow", async function() {
    const SubOverflow = await ethers.getContractFactory("SubOverflow");
    const subOverflow = await SubOverflow.deploy();
    let resultAssembly = parseInt(await subOverflow.subtract(3, 4));
    assert.equal(resultAssembly, 0);
  });
});
