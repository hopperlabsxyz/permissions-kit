import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve, oneOf } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";
import { Target } from "bun";

const PendleRouterV4_base = "0x888888888889758F76e7103c6CbF23ABbF58F946"; //proxy
const targetMarket_base = "0x715509Bde846104cF2cCeBF6fdF7eF1BB874Bc45"; //market
const USR_base = "0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9"; //usr_base

const pendleRouters = {
  8453: "0x888888888889758F76e7103c6CbF23ABbF58F946", // base pendleRouterV4
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

function depositToken(chainId: ChainId, tokens: Address[]): Permission[] {
  const pendleRouter = getRouterAddress(chainId);
  return [
    ...allowErc20Approve(tokens, [getRouterAddress(chainId)]), // manage approval for redemption from safe to vault
    {
      ...allow.base.pendle.ActionAddRemoveLiqV3.addLiquiditySingleToken(
        c.avatar,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined
      ),
      targetAddress: PendleRouterV4_base,
    },
  ];
}

export interface tokens {
  address: Address;
}

export const base = {
  depositToken: async ({ tokens }: { tokens: Address[] }) => {
    if (tokens.length === 0) {
      throw new Error("No tokens provided");
    }
    return tokens.flatMap((token) => {
      return depositToken(8453, [token]);
    });
  },
};
