import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve, oneOf } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";

const oftAdapters = {
  1: '0xD2eE2776F34Ef4E7325745b06E6d464b08D4be0E'
} as const

const chainIdToEndpointId = {
  1: 30101, // mainnet
  10: 30111, // optimism
  100: 30145, // gnosis
  137: 30109, // polygon
  42161: 30110, // arbitrum
  43114: 30106, // avalance
  56: 30102, // bnb
  8453: 30184, // base
} as const

function getOFTAdapterAddress(chainId: ChainId) {
  if (chainId in oftAdapters) {
    return oftAdapters[chainId as keyof typeof oftAdapters];
  }
  throw new Error(`OFT Adapters addresses not supported on this chain id: ${chainId}`)
}


function stargateTransfer(chainId: ChainId, tokens: Address[], dstChainIds: number[], receiver: Address): Permission[] {
  const endpointIds = dstChainIds.map((chainId) => {
    if (chainId in chainIdToEndpointId) {
      return chainIdToEndpointId[chainId as keyof typeof chainIdToEndpointId]
    }
    return chainId
  })

  const oftAdapter = getOFTAdapterAddress(chainId)

  return [
    ...allowErc20Approve(tokens, [oftAdapter]),
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


type Target = { tokenAddresses: Address[], dstChainIds: number[], receiver: Address }


export const eth = {
  stargate: {
    transfer: async ({ targets }: { targets: Target[] }) => {
      return targets.flatMap(({ tokenAddresses, dstChainIds, receiver }) => stargateTransfer(1, tokenAddresses, dstChainIds, receiver))
    },
  }
};

//TODO: add tests for approve : Ok
//TODO: add tests for transfer : Ok
//TODO: add addresses for other chains
//TODO: add chainId to oftAdapters