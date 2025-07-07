import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve, oneOf } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";
import { Target, Targets, TargetInfo } from "./types";
import baseMarkets from "./_baseMarkets.ts";

function getTargetInfo(target: Target): TargetInfo {
  if (typeof target === "string") {
    const market = baseMarkets.find((t) => t.address === target);
    if (market === undefined) {
      throw new Error("Unknown target");
    }
    return market;
  }
  return {
    symbol: target.symbol,
    name: target.name,
    address: target.address,
    underlying: target.underlying,
  };
}

const pendleRouters = {
  8453: "0x888888888889758F76e7103c6CbF23ABbF58F946", // base pendleRouterV4
} as const;

function getRouterAddress(chainId: ChainId) {
  if (chainId in pendleRouters) {
    return pendleRouters[chainId as keyof typeof pendleRouters];
  }
  throw new Error(
    `Pendle router addresses not supported on this chain id: ${chainId}`
  );
}

function deposit(chainId: ChainId, targetInfo: TargetInfo): Permission[] {
  const pendleRouter = getRouterAddress(chainId);
  return [
    ...allowErc20Approve([targetInfo.underlying], [pendleRouter]),
    {
      ...allow.base.pendle.ActionAddRemoveLiqV3.addLiquiditySingleToken(
        c.avatar,
        targetInfo.address,
        undefined,
        undefined,
        undefined,
        undefined

      ),
      targetAddress: pendleRouter,
    },
    {
      ...allow.base.pendle.ActionAddRemoveLiqV3.removeLiquiditySingleToken(
        c.avatar,
        targetInfo.address,
        undefined,
        undefined,
        undefined,
      ),
      targetAddress: pendleRouter,
    },
  ];
}

export interface tokens {
  address: Address;
}

export const base = {
  deposit: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) =>
      deposit(8453, getTargetInfo(target))
    );
  },
};
