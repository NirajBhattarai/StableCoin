// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";

contract DeployDecentralizedStable is Script {
    function run() external returns (DecentralizedStableCoin) {
        vm.startBroadcast();
        // TODO: will fetch the config from the helper config later on
        HelperConfig helperConfig = new HelperConfig();
        DecentralizedStableCoin decentralizedStableCoin = deployContract(msg.sender);
        vm.stopBroadcast();
        return decentralizedStableCoin;
    }

    function deployContract(address owner) public returns (DecentralizedStableCoin) {
        DecentralizedStableCoin decentralizedStableCoin = new DecentralizedStableCoin(owner);
        return decentralizedStableCoin;
    }
}
