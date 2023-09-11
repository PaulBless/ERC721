const { expect } = require("chai");

describe("MyNFT", function () {
    let MyNFT;
    let myNFT;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        MyNFT = await ethers.getContractFactory("MyNFT");
        myNFT = await MyNFT.deploy();
        await myNFT.deployed();
    });

    it("Should deploy with the right name and symbol", async function () {
        expect(await myNFT.name()).to.equal("MyNFT");
        expect(await myNFT.symbol()).to.equal("MNFT");
    });

    it("Should mint a token and set the owner", async function () {
        await myNFT.mint(addr1.address, 1);
        expect(await myNFT.ownerOf(1)).to.equal(addr1.address);
    });

    it("Should not allow minting by non-owner", async function () {
        await expect(myNFT.connect(addr1).mint(addr2.address, 2)).to.be.revertedWith("Ownable: caller is not the owner");
    });
});
