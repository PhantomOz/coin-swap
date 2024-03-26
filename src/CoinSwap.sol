// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {FeedRegistryInterface} from "@chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";

contract CoinSwap {
    address public wEthToken;
    address public linkToken;
    address public daiToken;

    address private feedRegistryAddress;

    FeedRegistryInterface private feedRegistry;

    event EthToLinkSwap(address indexed sender, uint256 amount);
    event EthToDaiSwap(address indexed sender, uint256 amount);
    event LinkToEthSwap(address indexed sender, uint256 amount);
    event LinkToDaiSwap(address indexed sender, uint256 amount);
    event DaiToEthSwap(address indexed sender, uint256 amount);
    event DaiToLinkSwap(address indexed sender, uint256 amount);

    constructor(
        address _wEthToken,
        address _linkToken,
        address _daiToken,
        address _feedRegistryAddress
    ) {
        wEthToken = _wEthToken;
        linkToken = _linkToken;
        daiToken = _daiToken;
        feedRegistryAddress = _feedRegistryAddress;
    }

    function swapEthToLink(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(wEthToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(wEthToken, linkToken, amount);
        IERC20(linkToken).transfer(msg.sender, amountOut);

        emit EthToLinkSwap(msg.sender, amount);
    }

    function swapEthToDai(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(wEthToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(wEthToken, daiToken, amount);
        IERC20(daiToken).transfer(msg.sender, amountOut);

        emit EthToDaiSwap(msg.sender, amount);
    }

    function swapLinkToEth(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(linkToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(linkToken, wEthToken, amount);
        IERC20(wEthToken).transfer(msg.sender, amountOut);

        emit LinkToEthSwap(msg.sender, amount);
    }

    function swapLinkToDai(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(linkToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(linkToken, daiToken, amount);
        IERC20(daiToken).transfer(msg.sender, amountOut);

        emit LinkToDaiSwap(msg.sender, amount);
    }

    function swapDaiToEth(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(daiToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(daiToken, wEthToken, amount);
        IERC20(wEthToken).transfer(msg.sender, amountOut);

        emit DaiToEthSwap(msg.sender, amount);
    }

    function swapDaiToLink(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(daiToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(daiToken, linkToken, amount);
        IERC20(linkToken).transfer(msg.sender, amountOut);

        emit DaiToLinkSwap(msg.sender, amount);
    }

    function _handleAmountOut(
        address base,
        address quote,
        uint256 amountIn
    ) internal view returns (uint256) {
        (, int256 priceIn, , , ) = feedRegistry.latestRoundData(base, quote);
        require(priceIn > 0, "Price feed not available for base asset");
        return uint256(amountIn * uint256(priceIn));
    }
}
