import * as lagoon from "./lagoon";
import * as resupply from "./resupply";
import * as curve from "./curve";
import * as convex from "./convex";
import * as bridge from "./bridge";
import * as pendle from "./pendle";
import * as lido from "./lido";
import * as etherfi from "./etherfi";
import * as se7enseas from "./se7enseas";

export const eth = {
  lagoon: lagoon.eth,
  resupply: resupply.eth,
  curve: curve.eth,
  convex: convex.eth,
  bridge: bridge.eth,
  lido: lido.eth,
  etherfi: etherfi.eth,
  se7enseas: se7enseas.eth,
};

export const base = {
  pendle: pendle.base,
  bridge: bridge.base,
};
