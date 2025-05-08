import { Address } from "@gnosis-guild/eth-sdk";
import { ConditionFunction } from "zodiac-roles-sdk/build/cjs/sdk/src/permissions/authoring/conditions/types";
import { BigNumberish } from "ethers";
import baseMarkets from "./_baseMarkets.ts";

type BaseMarket = (typeof baseMarkets)[number];

export interface TargetInfo {
  symbol: string;
  name: string;
  address: Address;
  asset: Address;
}

export interface UnknownMarket {
  symbol: string;
  name: string;
  address: Address;
  asset: Address;
}

export type Target = BaseMarket["address"]| {
      market: BaseMarket["address"] | UnknownMarket;
      asset: BaseMarket["asset"];
    };

export type Targets = Target[];
