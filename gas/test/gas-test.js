const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Gas1", function () {
  let gasContract;
  let owner, addr1, addr2, addr3;
  let importantStruct = [101, 100000000000000, 202];

  beforeEach(async function () {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();

    const Gas1 = await ethers.getContractFactory("GasContract");
    let admins = [
      "0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2",
      "0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46",
      "0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf",
      "0xeadb3d065f8d15cc05e92594523516aD36d1c834",
      owner.address,
    ];
    gasContract = await Gas1.deploy(admins, 10000);
    await gasContract.deployed();
  });
  it("Check that admins have been added", async function () {
    expect(await gasContract.administrators(0)).to.equal(
      "0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2"
    );
    expect(await gasContract.administrators(1)).to.equal(
      "0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46"
    );
    expect(await gasContract.administrators(2)).to.equal(
      "0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf"
    );
    expect(await gasContract.administrators(3)).to.equal(
      "0xeadb3d065f8d15cc05e92594523516aD36d1c834"
    );
    expect(await gasContract.administrators(4)).to.equal(owner.address);
  });
  it("Checks that the total supply is 10000", async function () {
    let supply = await gasContract.totalSupply();
    expect(supply).to.equal(10000);
  });
  it("Checks a transfer", async function () {
    // owner has total supply, transfer 100

    const transferTx = await gasContract.transfer(addr1.address, 100, "acc1");
    await transferTx.wait();
    let acc1Balance = await gasContract.balanceOf(addr1.address);
    expect(acc1Balance).to.equal(100);
  });

  it("Checks an update", async function () {
    // create a transfer then update

    const transferTx1 = await gasContract.transfer(addr1.address, 300, "acc1");
    await transferTx1.wait();
    const transferTx2 = await gasContract.transfer(addr1.address, 200, "acc1");
    await transferTx2.wait();
    const transferTx3 = await gasContract.transfer(addr1.address, 100, "acc1");
    await transferTx3.wait();
    const transferTx4 = await gasContract.transfer(addr2.address, 300, "acc2");
    await transferTx4.wait();
    const transferTx5 = await gasContract.transfer(addr2.address, 100, "acc2");
    await transferTx5.wait();
    let acc1Balance = await gasContract.balanceOf(addr1.address);
    expect(acc1Balance).to.equal(600);
    let acc2Balance = await gasContract.balanceOf(addr2.address);
    expect(acc2Balance).to.equal(400);
    const updateTx = await gasContract.updatePayment(owner.address, 1, 302, 3);
    await updateTx.wait();
    // now need to check the update
    const Payments = await gasContract.getPayments(owner.address);

    expect(Payments.length).to.equal(5);
    expect(Payments[0].amount).to.equal(302);
    expect(Payments[0].paymentType).to.equal(3);
  });

  it("Checks for events", async function () {
    // create a transfer then update
    await expect(gasContract.transfer(addr1.address, 300, "acc1"))
      .to.emit(gasContract, "Transfer")
      .withArgs(addr1.address, 300);
  });

  it("Checks for admin", async function () {
    await expect(
      gasContract.connect(addr1).updatePayment(owner.address, 1, 302, 3)
    ).to.be.reverted;
  });
  it("Ensure trading mode is set", async function () {
    let mode = await gasContract.getTradingMode();
    expect(mode).to.equal(true);
  });

  //CAN BE adjusted to a level
  it("Add users to whitelist and validate key users are added with correct tier", async function () {
    await addToWhitelist();
    let whitelistAddr1 = await gasContract.whitelist(addr1.address);
    expect(parseInt(whitelistAddr1)).to.equal(1);
    let whitelistAddr2 = await gasContract.whitelist(addr2.address);
    expect(parseInt(whitelistAddr2)).to.equal(2);
    let whitelistAddr3 = await gasContract.whitelist(addr3.address);
    expect(parseInt(whitelistAddr3)).to.equal(3);
  });
  it("Whitelist transfer works", async function () {
    await addToWhitelist();
    const transferTx1 = await gasContract.transfer(addr1.address, 500, "acc1");
    await transferTx1.wait();
    const transferTx2 = await gasContract.transfer(addr2.address, 300, "acc2");
    await transferTx2.wait();
    const transferTx3 = await gasContract.transfer(addr3.address, 100, "acc2");
    await transferTx3.wait();
    let recipient1 = ethers.Wallet.createRandom();
    let recipient2 = ethers.Wallet.createRandom();
    let recipient3 = ethers.Wallet.createRandom();
    let sendValue1 = 250;
    let sendValue2 = 150;
    let sendValue3 = 50;
    const whiteTransferTx1 = await gasContract
      .connect(addr1)
      .whiteTransfer(recipient1.address, sendValue1, importantStruct);
    await whiteTransferTx1.wait();
    const whiteTransferTx2 = await gasContract
      .connect(addr2)
      .whiteTransfer(recipient2.address, sendValue2, importantStruct);
    await whiteTransferTx2.wait();
    const whiteTransferTx3 = await gasContract
      .connect(addr3)
      .whiteTransfer(recipient3.address, sendValue3, importantStruct);
    await whiteTransferTx3.wait();
    let rec1Balance = await gasContract.balanceOf(recipient1.address);
    let rec2Balance = await gasContract.balanceOf(recipient2.address);
    let rec3Balance = await gasContract.balanceOf(recipient3.address);
    expect(sendValue1 - 1).to.equal(rec1Balance);
    expect(sendValue2 - 2).to.equal(rec2Balance);
    expect(sendValue3 - 3).to.equal(rec3Balance);
    let acc1Balance = await gasContract.balanceOf(addr1.address);
    let acc2Balance = await gasContract.balanceOf(addr2.address);
    let acc3Balance = await gasContract.balanceOf(addr3.address);
    expect(sendValue1 + 1).to.equal(acc1Balance);
    expect(sendValue2 + 2).to.equal(acc2Balance);
    expect(sendValue3 + 3).to.equal(acc3Balance);
  });

  async function addToWhitelist() {
    let addrArray1 = [];
    let addrArray2 = [];
    let addrArray3 = [];
    for (let i = 0; i < 99; i++) {
      let wallet = ethers.Wallet.createRandom();
      addrArray1.push(wallet.address);
    }

    let tx0 = await gasContract.addToWhitelist(addr1.address, 1);
    await tx0.wait();
    addrArray1.forEach(async (element) => {
      let tx1 = await gasContract.addToWhitelist(element, 1);
      await tx1.wait();
    });

    for (let i = 0; i < 199; i++) {
      let wallet = ethers.Wallet.createRandom();
      addrArray2.push(wallet.address);
    }
    addrArray2.push(addr2.address);
    addrArray2.forEach(async (element) => {
      let tx2 = await gasContract.addToWhitelist(element, 2);
      await tx2.wait();
    });
    for (let i = 0; i < 299; i++) {
      let wallet = ethers.Wallet.createRandom();
      addrArray3.push(wallet.address);
    }
    addrArray3.push(addr3.address);
    addrArray3.forEach(async (element) => {
      let tx3 = await gasContract.addToWhitelist(element, 3);
      await tx3.wait();
    });
  }
});
