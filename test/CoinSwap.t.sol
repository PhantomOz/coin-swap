// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CoinSwap} from "../src/CoinSwap.sol";

contract CoinSwapTest is Test {
    CoinSwap public coinswap;

    function setUp() public {
        coinswap = new CoinSwap();
    }

    function test__swapEthToLink() external {
        vm.prank();
        coinswap.swapEthToLink();
    }

    function test__swapEthToDai() external {
        vm.prank();
        coinswap.swapEthToDai(amount);
    }

    function test__swapLinkToEth() external {
        vm.prank();
        coinswap.swapLinkToEth();
    }

    function test__swapLinkToDai() external {
        vm.prank();
        coinswap.swapLinkToDai();
    }

    function test__swapDaiToEth() external {
        vm.prank();
        coinswap.swapDaiToEth();
    }

    function test__swapDaiToLink() external {
        vm.prank();
        coinswap.swapDaiToLink();
    }
}
