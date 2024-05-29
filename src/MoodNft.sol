// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

/**
 * @title
 * @author ge1u
 * @notice
 */
contract MoodNft is ERC721 {
    // errors
    error MoodNft__CannotFlipMoodIfNotOwner();

    // Type declarations
    enum Mood {
        HAPPY,
        SAD
    }

    // State variables
    uint256 private s_tokenCounter;
    string private s_sadSvgImgUri;
    string private s_happySvgImgUri;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    // Events

    // Modifiers

    // constructor
    constructor(string memory sadSvgImgUri, string memory happySvgImgUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImgUri = sadSvgImgUri;
        s_happySvgImgUri = happySvgImgUri;
    }

    // receive function (if exists)
    // fallback function (if exists)

    // external

    // public
    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImgUri;
        } else {
            imageURI = s_sadSvgImgUri;
        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function flipMood(uint256 tokenId) public {
        if (!_isAuthorized(ownerOf(tokenId), msg.sender, tokenId)) {
            revert MoodNft__CannotFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    // internal
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }
    // private
    // internal & private view & pure functions
    // external & public view & pure functions
    function getSadSvgImgUri() public view returns (string memory) {
        return s_sadSvgImgUri;
    }
    function getHappySvgImgUri() public view returns (string memory) {
        return s_happySvgImgUri;
    }
    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
    function getTokenIdToMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}
