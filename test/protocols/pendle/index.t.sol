// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import {IActionAddRemoveLiqV3} from "@test/interfaces/base/IActionAddRemoveLiqV3.sol";
import "@forge-std/Test.sol";

// Moved to base folder, mainnet is not supported for now
