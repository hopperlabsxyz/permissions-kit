import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve, oneOf } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Address } from "@gnosis-guild/eth-sdk";
import { Target, Targets, TargetInfo } from "./types";
import baseMarkets from "./_baseMarkets.ts";

function getTargetInfo(target: Target): TargetInfo {
  if (typeof target === "string") {
    const res = baseMarkets.find((t) => t.address === target);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return res;
  } else if (typeof target.market === "string") {
    const res = baseMarkets.find((t) => t.address === target.market);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return {
      symbol: res.symbol,
      name: res.name,
      address: res.address,
      underlying: res.underlying,
    };
  }
  return {
    symbol: target.market.symbol,
    name: target.market.name,
    address: target.market.address,
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

function depositToken(chainId: ChainId, targetInfo: TargetInfo): Permission[] {
  const pendleRouter = getRouterAddress(chainId);
  return [
    ...allowErc20Approve([targetInfo.underlying], [pendleRouter]),
    {
      ...allow.base.pendle.ActionAddRemoveLiqV3.addLiquiditySingleToken(
        c.avatar,
        targetInfo.address,
        undefined
      ),
      targetAddress: pendleRouter,
    },
  ];
}

export interface tokens {
  address: Address;
}

export const base = {
  depositToken: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) =>
      depositToken(8453, getTargetInfo(target))
    );
  },
};
