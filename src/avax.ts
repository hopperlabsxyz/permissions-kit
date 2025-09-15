import { allow as zAllow } from "zodiac-roles-sdk/kit";
import { avax as allowProtocols } from "./protocols";

export const EVERYTHING = Symbol("EVERYTHING");

export const allow = zAllow.avalanche;
export const kit = allowProtocols;
