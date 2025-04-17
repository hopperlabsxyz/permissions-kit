import { Address } from "@gnosis-guild/eth-sdk";
import _ethPools from "./_ethPools";

type EthPool = (typeof _ethPools)[number];

export interface TargetInfo {
  address: Address
  token0: Address;
  token1: Address;
}

export type Target = EthPool['address'] | TargetInfo;

export type Targets = Target[];
