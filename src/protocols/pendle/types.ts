import { Address } from "@gnosis-guild/eth-sdk";
import baseMarkets from "./_baseMarkets.ts";

type BaseMarket = (typeof baseMarkets)[number];

export interface TargetInfo {
  symbol: string;
  name: string;
  address: Address;
  underlying: Address;
}

export interface UnknownMarket {
  symbol: string;
  name: string;
  address: Address;
  underlying: Address;
}

export type Target =
  | BaseMarket["address"]
  | {
      market: BaseMarket["address"] | UnknownMarket;
      underlying: BaseMarket["underlying"];
    };

export type Targets = Target[];
