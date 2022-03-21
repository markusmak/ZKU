// contracts/nft.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./merkle.sol";

contract MyNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    bytes32[] merkle;
    uint[] layerLength;
    Merkle m;

    constructor() ERC721("MyNFT", "MAK") {
        m = new Merkle();
    }

    struct Details {
        address sender;
        address receiver;
        uint tokenId;
        string tokenURI;
    }

    function mint(address addr, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(addr, newItemId);
        _setTokenURI(newItemId, tokenURI);
        Details d = Details(msg.sender, addr, newItemId, tokenURI);
        m.appendMerkle(keccak256(abi.encodePacked(d.sender, d.receiver, d.tokenId, d.tokenURI)));
        return newItemId;
    }
}