// Load dependencies
const { expect } = require("chai");

let DexGov;
let dexGov;
let owner;
let addr1;

describe("DexGov Contract", function () {
  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    DexGov = await ethers.getContractFactory("DexGov");
    dexGov = await DexGov.deploy(await owner.getAddress());
    await dexGov.deployed();
  });

  describe("Deployment", async function () {
    it("Should assign the total supply of GOV tokens to the owner", async function () {
      const ownerBalance = await dexGov.balanceOf(owner.address, 1);
      expect(await dexGov.GOV_SUPPLY()).to.equal(ownerBalance);
    });

    it("Should assign the total supply of FUEL tokens to the owner", async function () {
      const ownerBalance = await dexGov.balanceOf(owner.address, 2);
      expect(await dexGov.FUEL_SUPPLY()).to.equal(ownerBalance);
    });
  });

  describe("Identity Creations", async function () {
    it("Should create new identity for shipper", async function () {
      const userType = await dexGov.addNewUser(addr1.address, 0);
      expect(userType.value).to.equal(0);
    });
  });
});
