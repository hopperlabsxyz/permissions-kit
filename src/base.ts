import { allow as zAllow } from "zodiac-roles-sdk/kit";
import { base as allowProtocols } from "./protocols";

export const EVERYTHING = Symbol("EVERYTHING");

export const allow = zAllow.base;
export const kit = allowProtocols;
