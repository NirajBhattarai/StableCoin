// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployDecentralizedStable} from "../../script/DeployDecentralizedStable.s.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {console} from "forge-std/console.sol";

contract DecentralizedStableCoinTest is Test {
    DeployDecentralizedStable public deployer;
    DecentralizedStableCoin public decentralizedStableCoin;
    address public USER = makeAddr("user");

    function setUp() public {
        vm.startPrank(USER);
        deployer = new DeployDecentralizedStable();
        decentralizedStableCoin = deployer.deployContract(USER);
        vm.stopPrank();
    }

    function test_RevertIfBurnAmountIsZero() public {
        console.log("USER: ", USER);
        console.log("decentralizedStableCoin: ", address(decentralizedStableCoin));
        console.log("Token owner: ", decentralizedStableCoin.owner());
        console.log("sender: ", msg.sender);
        console.log("tx.origin: ", tx.origin);
        vm.prank(USER);
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin_MustBeMoreThanZero.selector);
        decentralizedStableCoin.burn(0);
    }

    function test_RevertIfBurnAmountExceedsBalance() public {
        vm.prank(USER);
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin_BurnAmountExceedsBalance.selector);
        decentralizedStableCoin.burn(1000000000000000000000000);
    }
}
