// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";
//import {HelperConfig} from "./helperconfig.s.sol";

contract deploy_Crowd_Funding  is Script {

    address public deployingAccount;
    function run() external returns (CrowdFunding, address){
        deployingAccount = msg.sender;
        vm.startBroadcast();
        CrowdFunding crowdFunding = new CrowdFunding(100, 60, 10);
        vm.stopBroadcast();
        return (crowdFunding, deployingAccount);
    }
}