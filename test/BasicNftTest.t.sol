// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public TOKEN_URI = "ipfs://QmQgEZ1unY52m4aZAo2PGtVe99kmPC1u8pRJp9MKFd7LQm";

    function setUp() external {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assertEq(expectedName, actualName);
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "DOG";
        string memory actualSymbol = basicNft.symbol();
        assertEq(expectedSymbol, actualSymbol);
    }

    function testTokenCounterStartsAtZero() public view {
        uint256 expectedTokenCounter = 0;
        uint256 actualTokenCounter = basicNft.getTokenCounter();
        assertEq(expectedTokenCounter, actualTokenCounter);
    }

    function testCanMintAndHaveATokenURI() public {
        vm.prank(USER);
        basicNft.mintNft(TOKEN_URI);
        string memory actualTokenURI = basicNft.tokenURI(0);
        assertEq(basicNft.balanceOf(USER), 1);
        assertEq(TOKEN_URI, actualTokenURI);
    }
}
