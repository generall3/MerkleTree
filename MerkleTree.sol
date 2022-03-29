// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Merkle tree

contract MerkleTree {
    bytes32[] public hashes;
    string[4] transactions = [
        "alice -> bob",
        "bob -> dave",
        "carol -> alice",
        "dave -> bob"
    ];

    constructor() {
        for (uint i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint count = transactions.length;
        uint offset = 0;

        while (count > 0) {
            for (uint i = 0; i < count - 1; i += 2) {
                hashes.push(keccak256(abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])));
            }
            offset +=count;
            count = count / 2;
        }
    }

    function verify(string memory transaction, uint index, bytes32 root, bytes32[] memory proof) public pure returns (bool) {
        // transcation: "alice -> bob"
        // index: 0
        // root hash: 0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7
        // proof elements hash: 
        // [1] 0x92ae03b807c62726370a4dcfecf582930f7fbb404217356b6160b587720d3ba7
        // [5] 0x2f71627ef88774789455f181c533a6f7a68fe16e76e7a50362af377269aabfee

        bytes32 hash = keccak256(abi.encodePacked(transaction));
        for(uint i = 0; i < proof.length; i++) {
            bytes32 element = proof[i];
            if ( index / 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, element));
            } else {
                hash = keccak256(abi.encodePacked(element, hash));
            }
            index = index / 2;
        }
        return hash == root;
    }

    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }

}