const { expect, assert } = require("chai");
const { ethers } = require("hardhat");
const { getEvmBytecode } = require("./helper");

describe("Token contract", async function() {
  beforeEach(async function() {
    Syntax4 = await ethers.getContractFactory("Syntax_4");
    syntax4 = await Syntax4.deploy();
  });

  it("Can't read variable theWay", async function() {
    let varSomethingExists;
    try {
      expect((await syntax4.theWay()).toString()).to.equal(
        "North West Passage is this way"
      );
      varSomethingExists = true;
    } catch {
      varSomethingExists = false;
    }
    expect(false, "Variable theWay should not be accessible").to.equal(
      varSomethingExists
    );
  });

  it("Can't invoke returnsCalc", async function() {
    let funcExists;
    try {
      let b = expect(await syntax4.calcAzimuth(10, 200));
      console.log("b: ", b);
      funcExists = true;
    } catch {
      funcExists = false;
    }

    expect(false, "Function calcAzimuth() should not be accessible").to.equal(
      funcExists
    );
  });

  it("Can read global variable distance", async function() {
    expect(
      parseInt(await syntax4.distance()),
      "Variable theWay should be accessible"
    ).to.equal(900);
  });

  it("Contract size is smaller", async function() {
    let bytecode = await getEvmBytecode();
    expect(bytecode.length, "Contract is is too large").to.be.lessThan(500);
  });
});
