import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve, oneOf } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";

const oftAdapters = {
  1: {
    ['0x66a1E37c9b0eAddca17d3662D6c05F4DECf3e110']: "0xD2eE2776F34Ef4E7325745b06E6d464b08D4be0E", // USR
    ['0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7']: "0x85d456B2DfF1fd8245387C0BfB64Dfb700e98Ef3" // rsETH
  },
  // 8453: {
  //   simpleOftAdapter: "0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9"
  // }
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
  146: 30332, // sonic
  130: 30320 // unichain
} as const;

type SupportedChainIds = keyof typeof chainIdToEndpointId

function getOFTAdapterAddress(chainId: ChainId, token: Address) {
  if (chainId === 1) {
    const adapters = oftAdapters[chainId];
    if (token in adapters) {
      return adapters[token as keyof typeof adapters]
    }
  }
  throw new Error(
    `OFT Adapter addresses not found on chain id ${chainId} for token ${token}. Please provide a custom oft adapter address in the optional parameters.`
  );
}

function getEndpointIds(chainsIds: SupportedChainIds[]): number[] {
  return chainsIds.map((chainId) => {
    if (chainId in chainIdToEndpointId) {
      return chainIdToEndpointId[chainId];
    }
    console.warn(`Chain id ${chainId} is not supported yet and has been removed from the destination list. If you need to pass Stargate destination ids directly, provide them into the dedicated optional params.`)
  }).filter((id) => id !== undefined);
}


function stargateTransfer(
  chainId: ChainId,
  token: Address,
  dstChainIds: SupportedChainIds[],
  receiver: Address,
  oftAdapter?: Address,
  customEndpointIds?: number[]
): Permission[] {
  let endpointIds = getEndpointIds(dstChainIds)
  if (customEndpointIds) {
    endpointIds = endpointIds.concat(customEndpointIds)
  }

  if (!oftAdapter) {
    oftAdapter = getOFTAdapterAddress(chainId, token);
  }

  return [
    ...allowErc20Approve([token], [oftAdapter]),
    {
      ...allow.mainnet.bridge.stargate.simpleOFTAdapter.send(
        c.matches({
          dstEid: oneOf(endpointIds),
          to: c.eq(receiver),
          amountLD: undefined,
          minAmountLD: undefined,
          extraOptions: undefined,
          composeMsg: undefined,
          oftCmd: undefined,
        }),
        undefined,
        c.avatar
      ),
      targetAddress: oftAdapter,
    },
  ];
}

interface Target {
  tokenAddress: Address;
  dstChainIds: SupportedChainIds[];
  receiver: Address;
};

export interface StargateTarget extends Target {
  oftAdapter?: Address,
  customEndpointIds?: number[]
}

export const eth = {
  stargate: {
    transfer: async ({ targets }: { targets: StargateTarget[] }) => {
      return targets.flatMap(({ tokenAddress: tokenAddresses, dstChainIds, receiver }) =>
        stargateTransfer(1, tokenAddresses, dstChainIds, receiver)
      );
    },
  },
};

export const base = {
  stargate: {
    transfer: async ({ targets }: { targets: StargateTarget[] }) => {
      return targets.flatMap(({ tokenAddress: tokenAddresses, dstChainIds, receiver }) =>
        stargateTransfer(8453, tokenAddresses, dstChainIds, receiver)
      );
    },
  },
};
