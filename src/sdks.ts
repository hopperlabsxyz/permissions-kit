import {
  getAvalancheSdk,
  getMainnetSdk,
} from "@gnosis-guild/eth-sdk-client"
import * as providers from "./provider"
import { Chain } from "../src/types"

export const sdks = {
  [Chain.eth]: getMainnetSdk(providers.ethProvider),
  [Chain.base]: getMainnetSdk(providers.baseProvider),
  [Chain.avax]: getAvalancheSdk(providers.avaxProvider),
}
