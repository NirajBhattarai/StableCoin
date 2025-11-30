// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {DSCEngine} from "../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {NetworkConfig} from "../script/HelperConfig.s.sol";
import {DeployDecentralizedStable} from "../script/DeployDecentralizedStable.s.sol";

contract DSCEngineTest is Test {
    DSCEngine public dsce;
    DecentralizedStableCoin public dsc;
    HelperConfig public helperConfig;
    NetworkConfig internal networkConfig;
    address public USER = makeAddr("user");

    function setUp() public {
        helperConfig = new HelperConfig();
        networkConfig = helperConfig.getActiveNetworkConfig();
        vm.startPrank(USER);
        DeployDecentralizedStable deployer = new DeployDecentralizedStable();
        dsc = deployer.deployContract(USER);

        dsce = new DSCEngine(networkConfig.collateralTokens, networkConfig.priceFeeds, address(dsc));
        vm.stopPrank();
    }

    function test_RevertIfTokenIsNotAllowed() public {
        address invalidToken = address(0x1234567890123456789012345678901234567890);
        vm.prank(USER);
        console.logBytes4(DSCEngine.DSCEngine_TokenNotAllowed.selector);
        bytes memory encodedError = abi.encodeWithSelector(DSCEngine.DSCEngine_TokenNotAllowed.selector, invalidToken);
        console.logBytes(encodedError);
        vm.expectRevert(encodedError);
        dsce.despositCollateral(invalidToken, 1000000000000000000000000);
    }

    function test_RevertIfAmountIsZero() public {
        vm.prank(USER);
        console.logBytes4(DSCEngine.DSCEngine_AmountMustBeMoreThanZero.selector);
        bytes memory encodedError = abi.encodeWithSelector(DSCEngine.DSCEngine_AmountMustBeMoreThanZero.selector);
        console.logBytes(encodedError);
        vm.expectRevert(encodedError);
        dsce.despositCollateral(networkConfig.collateralTokens[0], 0);
    }

    function test_RevertIfUserDoesNotHaveEnoughAllowance() public {
        uint256 amount = 1000000000000000000000000;
        vm.prank(USER);
        vm.expectRevert(abi.encodeWithSelector(DSCEngine.DSCEngine_TransferFailed.selector));
        dsce.despositCollateral(networkConfig.collateralTokens[0], amount);
    }
}
