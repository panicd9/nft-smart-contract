// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

import {Nft} from "../src/Nft.sol";

contract DeployNft is Script {
    function run() external returns (Nft) {
        // Start broadcasting transactions
        vm.startBroadcast();
        
        // Deploy the NFT contract
        Nft nft = new Nft();
        
        // Log deployment information
        console.log("NFT contract deployed to:", address(nft));
        console.log("Total supply:", nft.TOTAL_SUPPLY());
        console.log("Registration price:", nft.REGISTRATION_PRICE());
        console.log("Minting price:", nft.MINTING_PRICE());
        
        // Stop broadcasting
        vm.stopBroadcast();
        
        return nft;
    }
}
