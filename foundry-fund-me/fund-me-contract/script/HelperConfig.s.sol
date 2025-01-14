// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetWorkingConfig public activeNetworkConfig;
    MockV3Aggregator mockPriceFeed;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetWorkingConfig {
        address priceFeed;
    }

    constructor() {
        handleNetworking();
    }

    function handleNetworking() public {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig()
        public
        pure
        returns (NetWorkingConfig memory)
    {
        NetWorkingConfig memory sepoliaConfig = NetWorkingConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig()
        public
        returns (NetWorkingConfig memory)
    {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetWorkingConfig memory anvilConfig = NetWorkingConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
