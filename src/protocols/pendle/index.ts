import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve, oneOf } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";
import { Target } from "bun";

const PendleRouterV4_base = "0x888888888889758F76e7103c6CbF23ABbF58F946"; //proxy
const targetMarket_base = "0x715509Bde846104cF2cCeBF6fdF7eF1BB874Bc45"; //market
const USR_base = "0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9"; //usr_base

const pendleRouters = {
  8453: "0x888888888889758F76e7103c6CbF23ABbF58F946", // base simpleOFT
} as const;

const chainIdToEndpointId = {
  1: 30101, // mainnet
  10: 30111, // optimism
  100: 30145, // gnosis
  137: 30109, // polygon
  42161: 30110, // arbitrum
  43114: 30106, // avalance
  56: 30102, // bnb
  8453: 30184, // base
} as const;

// function getRouterAddress(chainId: ChainId) {
//   if (chainId in pendleRouters) {
//     return pendleRouters[chainId as keyof typeof pendleRouters];
//   }
//   throw new Error(
//     `Pendle router addresses not supported on this chain id: ${chainId}`
//   );
// }

// steps: white list the router address
// approve the router address to spend the tokens
// add liquidity to the router address
// -> so this function will take chainId, market address and deposit token address
// and return a list of permissions

function getRouterAddress(chainId: ChainId) {
  if (chainId in pendleRouters) {
    return pendleRouters[chainId as keyof typeof pendleRouters];
  }
  throw new Error(
    `Pendle router addresses not supported on this chain id: ${chainId}`
  );
}


function depositToken(
  chainId: ChainId,
  tokens: Address[]
  //   targetAddress: Address[]
): Permission[] {
  // const endpointIds = dstChainIds.map((chainId) => {
  //     if (chainId in chainIdToEndpointId) {
  //       return chainIdToEndpointId[chainId as keyof typeof chainIdToEndpointId];
  //     }
  //     return chainId;
  //   });
  const pendleRouter = getRouterAddress(chainId);
  return [
    ...allowErc20Approve(tokens, [getRouterAddress(chainId)]), // manage approval for redemption from safe to vault
    {
      ...allow.base.pendle.ActionAddRemoveLiqV3.addLiquiditySingleToken(
        c.avatar, // address receiver,
        undefined, // address market
        // targetMarket_base, // address market, //or 
        undefined, // uint256 minLpOut, //minimum amount of LP tokens to receive
        undefined, // ApproxParams calldata guessPtReceivedFromSy, //guess of the amount of PT tokens received from SY
        undefined, // TokenInput calldata input, //input token
        undefined // LimitOrderData calldata limit //limit order data
      ),
      targetAddress: PendleRouterV4_base,
    },
  ];
}

// export type Targets = Target[]
//to deposit, I need a chainId and a list of tokens
export interface tokens {
  address: Address
}

export const base = {
//   depositToken: async ({ tokens }: { tokens: Address[] }) => {
//     return depositToken(8453, tokens);
//   },
  depositToken: async ({ tokens }: { tokens: Address[] }) => {
    if (tokens.length === 0) {
      throw new Error("No tokens provided");
    }
    return tokens.flatMap((token) => {depositToken(8453, [token])});
  },
//   depositToken1: async ({ targets }: { targets: Address[] }) => {
//     return targets.flatMap((target) => {depositToken(8453, [target])});
//   },
//   manageVault: async ({ targets }: { targets: Targets }) => {
//     return targets.flatMap((target) => manageVault(1, getTargetInfo(target)));
//   },
};

//contract: PendleV2_base
//address: 0x888888888889758F76e7103c6CbF23ABbF58F946
//{
// "func": "addLiquiditySingleToken",
// "params": [
//         "0x2ff1E8C719ce789E66A7dD0Cf7bf9F6a932099Cf",//avatar
//         "0x715509Bde846104cF2cCeBF6fdF7eF1BB874Bc45",//market USR-BASE-SEP2025
//         1680569955603647139, // minLpOut
//         [//
//             259245242811312256,
//             544415009903755737,
//             518490485622624512,
//             30,
//             1000000000000
//         ],
//         [
//             "0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9",
//             4557235367107917288,
//             "0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9",
//             "0x0000000000000000000000000000000000000000",
//             [
//                 0,
//                 "0x0000000000000000000000000000000000000000",
//                 "",
//                 false
//             ]
//         ],
//         [
//             "0x0000000000000000000000000000000000000000",
//             0,
//             [],
//             [],
//             ""
//         ]
//     ]
// }
