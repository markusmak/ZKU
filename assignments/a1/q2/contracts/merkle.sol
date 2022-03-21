// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Merkle {
  
  mapping (uint => bytes32[]) public merkle;
  bytes32 public root;
  uint numLayers;

  constructor() {}

  function appendMerkle(bytes32 newHash) public {
    recurseMerkle(newHash, 0, false);
  }

  function recurseMerkle(bytes32 newHash, uint layer, bool update) private {
    uint length = merkle[layer].length;
    if (length == 0) {
      merkle[layer].push(newHash);
      root = newHash;
      numLayers = layer;
    } else {
      if (update) {
        merkle[layer][length - 1] = newHash;
      } else {
        merkle[layer].push(newHash);
        length = merkle[layer].length;
      }

      if (length % 2 == 0) {
        newHash = hashNum(merkle[layer][length - 2], newHash);
        update = true;
      } else {
        update = false;
      }
      recurseMerkle(newHash, layer + 1, update);
    }
  }

  function updateMerkle (bytes32 newHash, bytes32 oldHash) public view {
    (bool success, uint index) = findIndex(oldHash);
    if (!success) {
      revert('Cannot find old hash in leaves');
    } else {
      for (uint i = 0; i < numLayers; i++) {
        if (index % 2 == 0) {
          if (index + 1 <= merkle[i].length) {
            newHash = hashNum(newHash, merkle[i][index + 1]);
          }
        } else {
          newHash = hashNum(merkle[i][index - 1], newHash);
        }
        index = index / 2;
      }
    }

    
  }

  function findIndex(bytes32 _hash) public view returns(bool, uint) {
    for (uint i = 0; i < merkle[0].length; i++) {
      if (merkle[0][i] == _hash) {
        return (true, i);
      }
    }
    return (false, 0);
  }

  function hashNum(bytes32 left, bytes32 right) public pure returns(bytes32) {
    return keccak256(abi.encodePacked(left, right));
  }
}