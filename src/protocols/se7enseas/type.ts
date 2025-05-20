import { Address } from "@gnosis-guild/eth-sdk";

export interface UnknownVault {
  boringVault: Address;
  teller: Address;
  assets: (Address | 'ETH')[]
}

export interface TargetInfo {
  boringVault: Address;
  teller: Address;
  assets: (Address | 'ETH')[];
}


export type Target = {
  vault: UnknownVault,
}

export type Targets = Target[]
