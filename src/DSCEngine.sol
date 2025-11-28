// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";

///////////////////
// Type Declarations
///////////////////

struct CollateralConfig {
    address underlyingToken; // The actual token
    address oracleAddress; // Price feed address
    uint8 tokenDecimals; // The number of decimals the token has
}

contract DSCEngine {
    ///////////////////
    // Errors
    ///////////////////

    error DSCEngine_TokenAddressesAndPriceFeedAddressesMustBeSameLength();

    ///////////////////
    // State Variables
    ///////////////////

    mapping(address token => CollateralConfig collateralConfig) private s_collateralTokens;

    DecentralizedStableCoin private immutable i_dsc;

    ///////////////////
    // Events
    ///////////////////
    event CollateralDeposited(address indexed user, address indexed currency, uint256 indexed amount);
    event CollateralRedeemed(address indexed user, address indexed currency, uint256 indexed amount);
    event DSCMinted(address indexed user, address indexed currency, uint256 indexed amount);
    event DSCBurned(address indexed user, address indexed currency, uint256 indexed amount);

    ///////////////////
    // Modifiers
    ///////////////////

    constructor(address[] memory collateralTokens, address[] memory priceFeedAddresses, address dscAddress) {
        if (collateralTokens.length != priceFeedAddresses.length) {
            revert DSCEngine_TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < collateralTokens.length; i++) {
            // Add to allowed tokens
            address token = collateralTokens[i];
            address priceFeed = priceFeedAddresses[i];
            s_collateralTokens[token] = CollateralConfig({
                underlyingToken: token,
                oracleAddress: priceFeed,
                tokenDecimals: IERC20Metadata(token).decimals()
            });
        }

        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    ///////////////////
    // External Functions
    ///////////////////

    function depositCollateralAndMintDsc(
        address user,
        address currency,
        uint256 amountCollateral,
        uint256 amountDscToMint
    ) public {
        // 1. Deposit the collateral
        // 2. Mint DSC
    }

    function redeemCollateralForDsc(address user, address currency, uint256 amountCollateral, uint256 amountDscToBurn)
        public
    {
        // 1. Burn the DSC
        // 2. Redeem the collateral
    }

    function despositCollateral(address tokenCollateralAddress, uint256 collateralAmount) public {
        // 1. Deposit the collateral
        // 2. Mint DSC
    }

    ///////////////////
    // Public Functions
    ///////////////////

    function redeemCollateral(address tokenCollateralAddress, uint256 collateralAmount) public {
        // 1. Burn the DSC
        // 2. Redeem the collateral
    }

    function mintDsc(uint256 amountDscToMint) public {
        // 1. Mint the DSC
        // 2. Return the DSC
    }

    function burnDsc(uint256 amountDscToBurn) public {
        // 1. Burn the DSC
        // 2. Return the DSC
    }

    ///////////////////
    // Internal Functions
    ///////////////////

    function _getAccountCollateralValue(address user) public view returns (uint256) {
        // 1. Get the collateral value
        // 2. Return the collateral value
    }

    ///////////////////
    // Private Functions
    ///////////////////

    function _getTokenAmountFromUsd(address token, uint256 usdAmount) public view returns (uint256) {
        // 1. Get the token amount
        // 2. Return the token amount
    }

    ///////////////////
    // View Functions
    ///////////////////

    function getTokenAmountFromUsd(address token, uint256 usdAmount) public view returns (uint256) {
        // 1. Get the token amount
        // 2. Return the token amount
    }

    function getUsdValue(address token, uint256 amount) public view returns (uint256) {
        // 1. Get the USD value
        // 2. Return the USD value
    }

    function getAccountCollateralValue(address user) public view returns (uint256) {}
}
