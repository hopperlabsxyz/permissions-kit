import { JsonRpcProvider } from "ethers";
import { Chain } from "./types";

export const CHAIN_ID = {
  [Chain.eth]: 1,
  [Chain.base]: 8453,
} as const;

export const ethProvider = new JsonRpcProvider("https://rpc.eth.gateway.fm", {
  chainId: CHAIN_ID[Chain.eth],
  name: "Ethereum",
});

export const baseProvider = new JsonRpcProvider("https://base.llamarpc.com", {
  chainId: CHAIN_ID[Chain.base],
  name: "Base",
});
