// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft public moodNft;

    address public USER = makeAddr("user");

    function setUp() external {
        DeployMoodNft deployMoodNft = new DeployMoodNft();
        moodNft = deployMoodNft.run();
    }

    function testFlipMoodToSad() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        moodNft.flipMood(0);
        vm.stopPrank();
        assert(moodNft.getTokenIdToMood(0)==MoodNft.Mood.SAD);
    }
}
