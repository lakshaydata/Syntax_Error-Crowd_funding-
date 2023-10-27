// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {CrowdFunding} from "../../src/CrowdFunding.sol";
import {deploy_Crowd_Funding} from "../../script/deployCrowdFunding.s.sol";

contract crowd_funding_test is Test {

    event SuccessfullyDonated(address indexed donar);

    CrowdFunding crowdFunding;
    address public who_deployed_the_contract;
    address user = makeAddr("USER");
    uint256 constant startingBalance = 10 ether;

    function setUp() external {
        deploy_Crowd_Funding  deployCrowdFunding = new deploy_Crowd_Funding();
        (crowdFunding, ) = deployCrowdFunding.run();
        vm.deal(user, startingBalance);
        who_deployed_the_contract = deployCrowdFunding.deployingAccount();
    }

    function testDonate() public {
        vm.prank(user);
        crowdFunding.Donate{value: 10e18}();
        //assert(address(crowdFunding).balance == 10e18);
        assertEq(crowdFunding.get_s_funders(0) , user);
        //assert(user.balance == 0);
    }

    function test_cannot_donate_deadline_crossed() public{
        vm.prank(user);
        vm.warp(block.timestamp + 60 + 1);
        vm.expectRevert();
        crowdFunding.Donate{value: 10e18}();

        }

    function test_cannot_donate_if_value_less_than_minimum_value() public {
        vm.prank(user);
        vm.warp(block.timestamp + 60 + 1);
        vm.expectRevert();
        crowdFunding.Donate{value: 0}();
    }

    function test_emit_succesfully_donated() public {
        vm.prank(user);
        vm.expectEmit(true, false, false, false, address(crowdFunding));//lastly this is he address of the contract while deploying which you are expecting event
       //jitne indexed parameter aane hai shayad utne true kardo;
       
        //the below line is the emit which i expect to occur
        emit SuccessfullyDonated(user);
        // the below  line is the line which tell that while calling the enterRaffle function this emit will occur.
        crowdFunding.Donate{value: 10e18}();
    }

    // function test_recieve() public {
    //     vm.prank(user);
    //     vm.expectRevert();
    //     crowdFunding.receive{value: 10e18}();
    // }

    function test_withdraw_revert_If_not_owner_tries() public {
        vm.prank(user);
        crowdFunding.Donate{value: 10e18}();
        console.log(address(crowdFunding).balance);
        vm.expectRevert();
        crowdFunding.withdraw();
        }
    function test_withdraw_If_owner_tries() public {
        vm.prank(user);
        crowdFunding.Donate{value: 10e18}();
        console.log(address(crowdFunding).balance);
        vm.prank(who_deployed_the_contract);
        crowdFunding.withdraw();
        assertEq(address(crowdFunding).balance , 0);
        }
}