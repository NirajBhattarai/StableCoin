// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {ERC20Mock} from "../test/mock/ERC20Mock.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

struct NetworkConfig {
    address[] collateralTokens;
    address[] priceFeeds;
}

contract HelperConfig is Script {
    error HelperConfig_UnsupportedChain();

    function getActiveNetworkConfig() public returns (NetworkConfig memory) {
        if (block.chainid == 1) {
            return getEthereumMainnetNetworkConfig();
        } else if (block.chainid == 137) {
            return getPolygonMainnetNetworkConfig();
        } else if (block.chainid == 31337) {
            return getAnvilNetworkConfig();
        } else {
            revert HelperConfig_UnsupportedChain();
        }
    }

    function getEthereumMainnetNetworkConfig() public pure returns (NetworkConfig memory) {
        address[] memory collateralTokens = new address[](2);
        address[] memory priceFeeds = new address[](2);

        // WETH
        collateralTokens[0] = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        priceFeeds[0] = address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);

        // BTC
        collateralTokens[1] = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
        priceFeeds[1] = address(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);

        return NetworkConfig({collateralTokens: collateralTokens, priceFeeds: priceFeeds});
    }

    function getPolygonMainnetNetworkConfig() public pure returns (NetworkConfig memory) {
        address[] memory collateralTokens = new address[](2);
        address[] memory priceFeeds = new address[](2);

        collateralTokens[0] = address(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);
        priceFeeds[0] = address(0xAB594600376Ec9fD91F8e885dADF0CE036862dE0);

        collateralTokens[1] = address(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);
        priceFeeds[1] = address(0x1B44F351485310577b222e649D4532Ed605c2f1D);

        return NetworkConfig({collateralTokens: collateralTokens, priceFeeds: priceFeeds});
    }

    function getAnvilNetworkConfig() public returns (NetworkConfig memory) {
        // For local testing, we'll use mock addresses
        // In a real scenario, you would deploy mock ERC20 tokens and mock price feeds
        vm.startBroadcast();
        address wethMock = address(new ERC20Mock("WETH", "WETH", address(this), 1000000000000000000000000));
        address wbtcMock = address(new ERC20Mock("WBTC", "WBTC", address(this), 1000000000000000000000000));
        address wethPriceFeedMock = address(new MockV3Aggregator(8, 2000_00000000));
        address wbtcPriceFeedMock = address(new MockV3Aggregator(8, 1000_00000000));
        vm.stopBroadcast();

        address[] memory collateralTokens = new address[](2);
        address[] memory priceFeeds = new address[](2);

        collateralTokens[0] = wethMock;
        priceFeeds[0] = wethPriceFeedMock;

        collateralTokens[1] = wbtcMock;
        priceFeeds[1] = wbtcPriceFeedMock;

        return NetworkConfig({collateralTokens: collateralTokens, priceFeeds: priceFeeds});
    }

    function getCollateralTokens(NetworkConfig memory networkConfig) public pure returns (address[] memory) {
        return networkConfig.collateralTokens;
    }

    function getPriceFeeds(NetworkConfig memory networkConfig) public pure returns (address[] memory) {
        return networkConfig.priceFeeds;
    }
}
