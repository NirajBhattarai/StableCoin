// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract HelperConfig is Script {
    error HelperConfig_UnsupportedChain();

    constructor() {
        if (block.chainid == 1) {
            // TODO: Add the mainnet configuration
        } else if (block.chainid == 137) {
            // TODO: Add the polygon configuration
        } else if (block.chainid == 31337) {
            // TODO: Add the hardhat configuration
        } else {
            revert HelperConfig_UnsupportedChain();
        }
    }
}
