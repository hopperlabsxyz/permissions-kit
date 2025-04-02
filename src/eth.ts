import { allow as zAllow } from "zodiac-roles-sdk/kit"
import { eth as allowProtocols } from "./protocols"

export const EVERYTHING = Symbol("EVERYTHING")

export const allow = zAllow.mainnet;
export const kit = allowProtocols;
