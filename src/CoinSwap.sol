// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} "@openzeppelin-contracts/contracts/interface/IERC20.sol";
import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {FeedRegistryInterface} from "lib/chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";

contract CoinSwap {
    address public ethToken;
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
        address _ethToken,
        address _linkToken,
        address _daiToken,
        address _feedRegistryAddress
    ) {
        ethToken = _ethToken;
        linkToken = _linkToken;
        daiToken = _daiToken;
        feedRegistryAddress = _feedRegistryAddress;
    }

    function swapEthToLink(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(ethToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(ethToken, linkToken, amount);
        IERC20(linkToken).transfer(msg.sender, amountOut);

        emit EthToLinkSwap(msg.sender, amount);
    }

    function swapEthToDai(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(ethToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(ethToken, daiToken, amount);
        IERC20(daiToken).transfer(msg.sender, amountOut);

        emit EthToDaiSwap(msg.sender, amount);
    }

    function swapLinkToEth(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(linkToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(linkToken, ethToken, amount);
        IERC20(ethToken).transfer(msg.sender, amountOut);

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
        uint256 amountOut = _handleAmountOut(daiToken, ethToken, amount);
        IERC20(ethToken).transfer(msg.sender, amountOut);

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

//0x514910771AF9Ca656af840dff83E8264EcF986CA Link mainnet
//0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 eth mainnet
// 0x6B175474E89094C44Da98b954EedeAC495271d0F dai mainnet
