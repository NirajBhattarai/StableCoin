// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {console} from "forge-std/console.sol";

import {OracleLib, AggregatorV3Interface} from "./libraries/OracleLib.sol";

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
    error DSCEngine_HealthFactorTooLow();
    error DSCEngine_MintFailed();

    ///////////////////
    // Types
    ///////////////////
    using OracleLib for AggregatorV3Interface;

    uint256 private constant PRECISION = 1e18;
    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;
    uint256 private constant LIQUIDATION_THRESHOLD = 50;
    uint256 private constant LIQUIDATION_PRECISION = 100;
    uint256 private constant MIN_HEALTH_FACTOR = 1;

    ///////////////////
    // State Variables
    ///////////////////

    mapping(address token => CollateralConfig collateralConfig) private s_collateralTokensConfigs;

    DecentralizedStableCoin private immutable i_dsc;

    address[] private s_collateralTokens;

    mapping(address user => mapping(address token => uint256 amount)) private s_userCollateralDeposited;

    mapping(address user => uint256 amount) private s_DSCMinted;

    ///////////////////
    // Events
    ///////////////////
    event CollateralDeposited(address indexed user, address indexed currency, uint256 indexed amount);
    event CollateralRedeemed(address indexed user, address indexed currency, uint256 indexed amount);
    event DSCMinted(address indexed user, uint256 indexed amount);
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
        // Transfer the collateral from the user to the engine
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
        s_DSCMinted[msg.sender] += amountDscToMint;

        _revertIfHealthFactorTooLow(msg.sender);

        bool minted = i_dsc.mint(msg.sender, amountDscToMint);
        if (!minted) {
            revert DSCEngine_MintFailed();
        }
        emit DSCMinted(msg.sender, amountDscToMint);
    }

    function burnDsc(uint256 amountDscToBurn) public {
        // 1. Burn the DSC
        // 2. Return the DSC
    }

    ///////////////////
    // Internal Functions
    ///////////////////

    function _revertIfHealthFactorTooLow(address sender) internal {
        if (_healthFactor(sender) < MIN_HEALTH_FACTOR) {
            revert DSCEngine_HealthFactorTooLow();
        }
    }

    function _healthFactor(address user) internal view returns (uint256) {
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);

        uint256 collateralAdjustedForThreshold = collateralValueInUsd * LIQUIDATION_THRESHOLD / LIQUIDATION_PRECISION;

        return (collateralAdjustedForThreshold * PRECISION) / totalDscMinted;
    }

    function _getAccountInformation(address user)
        internal
        view
        returns (uint256 totalDscMinted, uint256 collateralValueInUsd)
    {
        totalDscMinted = s_DSCMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
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
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_collateralTokensConfigs[token].oracleAddress);
        (, int256 priceFeedAnswer,,,) = priceFeed.staleCheckLatestRoundData();
        uint8 decimals = priceFeed.decimals();

        return (uint256(priceFeedAnswer) * amount) / (10 ** decimals);
    }

    function getAccountCollateralValue(address user) public view returns (uint256 totalCollateralValue) {
        for (uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_userCollateralDeposited[user][token];
            totalCollateralValue += getUsdValue(token, amount);
        }

        console.log("---->totalCollateralValue", totalCollateralValue);
    }

    function getUserCollateralDeposited(address user, address token) public view returns (uint256) {
        return s_userCollateralDeposited[user][token];
    }
}
