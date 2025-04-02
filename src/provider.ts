import { JsonRpcProvider } from "ethers"
import { Chain } from "./types"

export const CHAIN_ID = {
  [Chain.eth]: 1,
} as const

export const ethProvider = new JsonRpcProvider("https://rpc.eth.gateway.fm", {
  chainId: CHAIN_ID[Chain.eth],
  name: "Ethereum",
})
