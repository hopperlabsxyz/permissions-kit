import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve, oneOf } from "../../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";
import { chainIdToEndpointId, oftAdapters, SupportedChainId } from "./type";


function getOFTAdapterAddress(chainId: ChainId, token: Address) {
  if (chainId === 1) {
    const adapters = oftAdapters[chainId];
    const lowerCaseToken = token.toLowerCase()
    if (lowerCaseToken in adapters) {
      return adapters[lowerCaseToken as keyof typeof adapters]
    }
  }
  else if (chainId === 8453) {
    const adapters = oftAdapters[chainId];
    const lowerCaseToken = token.toLowerCase()
    if (lowerCaseToken in adapters) {
      return adapters[lowerCaseToken as keyof typeof adapters]
    }
  }
  throw new Error(
    `OFT Adapter addresses not found on chain id ${chainId} for token ${token}. Please provide a custom oft adapter address in the optional parameters.`
  );
}

function getEndpointIds(chainsIds: SupportedChainId[]): number[] {
  return chainsIds.map((chainId) => {
    if (chainId in chainIdToEndpointId) {
      return chainIdToEndpointId[chainId];
    }
    console.warn(`Chain id ${chainId} is not supported yet and has been removed from the destination list. If you need to pass Stargate destination ids directly, provide them into the dedicated optional params.`)
  }).filter((id) => id !== undefined);
}


export function stargateTransfer(
  fromChainId: ChainId,
  token: Address,
  toChainIds: SupportedChainId[],
  oftAdapter?: Address,
  customEndpointIds?: number[]
): Permission[] {
  let endpointIds = getEndpointIds(toChainIds)
  if (customEndpointIds) {
    endpointIds = endpointIds.concat(customEndpointIds)
  }

  if (!oftAdapter) {
    oftAdapter = getOFTAdapterAddress(fromChainId, token);
  }

  return [
    ...allowErc20Approve([token], [oftAdapter]),
    {
      ...allow.mainnet.bridge.stargate.simpleOFTAdapter.send(
        c.matches({
          dstEid: oneOf(endpointIds),
          to: c.avatar,
          amountLD: undefined,
          minAmountLD: undefined,
          extraOptions: undefined,
          composeMsg: undefined,
          oftCmd: undefined,
        }),
        undefined,
        c.avatar,
        { send: true }
      ),
      targetAddress: oftAdapter,
    },
  ];
}
