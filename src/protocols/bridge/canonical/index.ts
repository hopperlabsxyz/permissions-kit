import { c, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";
import { FromChainId, ToChainId } from "./type";
import { allow } from "zodiac-roles-sdk/kit";

const canonicalBridges = {
  1: {
    130: "0x81014F44b0a345033bB2b3B21C7a1A308B35fEeA", // unichain
    8453: "0x3154Cf16ccdb4C6d922629664174b904d80F2C35" // base
  } // TODO: add more chains
} as const

function getCanonicalBridges(fromChainId: FromChainId, toChainIds: ToChainId[]) {
  const bridges = canonicalBridges[fromChainId];
  return Object.entries(bridges)
    .filter(([k,]) => toChainIds.includes(Number(k) as any))
    .map(([, value]) => (value))
}

export function canonicalTransfer(
  fromChainId: FromChainId,
  toChainIds: ToChainId[],
  customBridgeAddresses?: Address[]
): Permission[] {

  let bridgesAddresses = getCanonicalBridges(fromChainId, toChainIds) as Address[];
  if (customBridgeAddresses) {
    bridgesAddresses = bridgesAddresses.concat(customBridgeAddresses)
  }

  return bridgesAddresses.flatMap(
    (targetAddress) => ([
      {
        ...allow.mainnet.bridge.canonical.l1ChugSplashProxy.bridgeETHTo(c.avatar, undefined, undefined, { send: true }),
        targetAddress
      },
      {
        ...allow.mainnet.bridge.canonical.l1ChugSplashProxy.finalizeBridgeETH(undefined, undefined, undefined, undefined),
        targetAddress
      }
    ])
  );
}
