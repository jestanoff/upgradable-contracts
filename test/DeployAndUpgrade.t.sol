// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Test } from "forge-std/Test.sol";
import { DeployBox } from "../script/DeployBox.s.sol";
import { UpgradeBox } from "../script/UpgradeBox.s.sol";
import { BoxV1 } from "../src/BoxV1.sol";
import { BoxV2 } from "../src/BoxV2.sol";

contract DeployAndUpgrade is Test {
  DeployBox deployer;
  UpgradeBox upgrader;
  address public OWNER = makeAddr("owner");
  address public proxy;

  function setUp() public {
    deployer = new DeployBox();
    upgrader = new UpgradeBox();
    proxy = deployer.run();
  }

  function testProxyStartsAsBoxV1() public {
    vm.expectRevert();
    BoxV2(proxy).setNumber(10223);
  }

  function testUpgrades() public {
    BoxV2 box2 = new BoxV2();

    upgrader.upgradeBox(proxy, address(box2));

    uint256 expectedValue = 2;
    assertEq(expectedValue, BoxV2(proxy).version());

    BoxV2(proxy).setNumber(7);
    assertEq(7, BoxV2(proxy).getNumber());
  }
}