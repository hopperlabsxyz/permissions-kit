import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { TargetInfo } from "../lagoon/types";

const USRToken = "0x66a1E37c9b0eAddca17d3662D6c05F4DECf3e110";
const Proxy_Resolv = "0xD2eE2776F34Ef4E7325745b06E6d464b08D4be0E";
const implementation = "0xc4543073bfaba77781b46dfb4d43b5ae4e30eb28";

//Note: Pendle Base USR
// Bridge USR back and forth
// Approve USR on Stargate Mainnet & Base
// https://stargate.finance/
// Bridge from and to Base & Mainnet
// LP USR on Pendle Base

function transfer(_: ChainId, targetAddress: TargetInfo): Permission[] {
  return [
    // Step 1: Approve USR to Stargate Proxy
    ...allowErc20Approve([Proxy_Resolv], [USRToken]),

    // Step 2: transfer USR to Base
    {
      ...allow.mainnet.bridge.SimpleOFTAdapter_resolv.send(
        // _sendParam
        c.matches({
          dstEid: undefined, // chainId
          to: undefined, // destination address
          amountLD: undefined, // amount to send
          // minAmountLD: c.gt(0), //min amount
          // extraOptions: c.any(), // Optional, allow dynamic
          // composeMsg: c.any(),
          // oftCmd: c.any()
        }),
        // _fee
        undefined,
        // _refundAddress
        c.avatar
      ),
      targetAddress: implementation,
    },
  ];
}

//Step 3: approve USR on Base
//Step 4: bridge USR back to mainnet

export const eth = {
  transfer: async ({ targets }: { targets: TargetInfo[] }) => {
    return targets.flatMap((target) => transfer(1, target));
  },
};

// TSX: transaction record
// From mainnet to base first, this is the first transactions: approve and send
// "{
//     "func": "approve",
//     "params": [
//         "0xD2eE2776F34Ef4E7325745b06E6d464b08D4be0E",
//         115792089237316195423570985008687907853269984665640564039457584007913129639935
//     ]
// }"
// "{
//     "func": "send",
//     "params": [
//         [
//             30184,
//             "000000000000000000000000208f33ae630a69c649c41fff2360537a99868b2a",
//             224836000000000000,
//             223712735839484713,
//             "0003",
//             "",
//             ""
//         ],
//         [
//             86491082257887,
//             0
//         ],
//         "0x208F33ae630a69c649c41ffF2360537a99868b2A"
//     ]
// }"
