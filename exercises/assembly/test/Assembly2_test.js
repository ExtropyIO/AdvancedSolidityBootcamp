const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Token contract", async function() {
  console.log("testing assembly");
  it("Conract deploys", async function() {
    const Add = await ethers.getContractFactory("Add");
    const add = await Add.deploy();
  });

  it("Both adds return same number", async function() {
    const Add = await ethers.getContractFactory("Add");
    const add = await Add.deploy();
    let resultAssembly = parseInt(await add.addAssembly(5, 4));
    let resultSolidity = parseInt(await add.addSolidity(5, 4));
    assert.equal(resultAssembly, resultSolidity);
  });
});
