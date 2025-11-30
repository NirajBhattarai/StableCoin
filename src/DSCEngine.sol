// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

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
    error DSCEngine_TokenNotAllowed(address token);
    error DSCEngine_AmountMustBeMoreThanZero();
    error DSCEngine_TransferFailed();

    ///////////////////
    // State Variables
    ///////////////////

    mapping(address token => CollateralConfig collateralConfig) private s_collateralTokensConfigs;

    DecentralizedStableCoin private immutable i_dsc;

    address[] private s_collateralTokens;

    mapping(address user => mapping(address token => uint256 amount)) private s_userCollateralDeposited;

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

    modifier isAllowedToken(address token) {
        if (s_collateralTokensConfigs[token].underlyingToken == address(0)) {
            revert DSCEngine_TokenNotAllowed(token);
        }
        _;
    }

    modifier moreThanZero(uint256 amount) {
        if (amount <= 0) {
            revert DSCEngine_AmountMustBeMoreThanZero();
        }
        _;
    }

    constructor(address[] memory collateralTokens, address[] memory priceFeedAddresses, address dscAddress) {
        if (collateralTokens.length != priceFeedAddresses.length) {
            revert DSCEngine_TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < collateralTokens.length; i++) {
            // Add to allowed tokens
            address token = collateralTokens[i];
            address priceFeed = priceFeedAddresses[i];
            s_collateralTokensConfigs[token] = CollateralConfig({
                underlyingToken: token,
                oracleAddress: priceFeed,
                tokenDecimals: IERC20Metadata(token).decimals()
            });
            s_collateralTokens.push(token);
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

    function despositCollateral(address tokenCollateralAddress, uint256 collateralAmount)
        public
        isAllowedToken(tokenCollateralAddress)
        moreThanZero(collateralAmount)
    {
        s_userCollateralDeposited[msg.sender][tokenCollateralAddress] += collateralAmount;

        // 1. Deposit the collateral
        // 2. Mint DSC
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), collateralAmount);
        if (!success) {
            revert DSCEngine_TransferFailed();
        }
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, collateralAmount);
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
