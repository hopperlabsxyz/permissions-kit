import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve, oneOf } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";

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
    ...allowErc20Approve(tokens, [pendleRouter]),
    {
      ...allow.base.pendle.ActionAddRemoveLiqV3.addLiquiditySingleToken(
        c.avatar,// address receiver,
        targetMarket_base, // address market,
        undefined,// uint256 minLpOut, //minimum amount of LP tokens to receive
        undefined,// ApproxParams calldata guessPtReceivedFromSy, //guess of the amount of PT tokens received from SY
        undefined,// TokenInput calldata input, //input token
        undefined// LimitOrderData calldata limit //limit order data
      ),
      targetAddress: PendleRouterV4_base,
    },
  ];
}

export const base = {
  depositToken: async ({ tokens }: { tokens: Address[] }) => {
    return depositToken(8453, tokens);
  },
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
