import { defineConfig } from "@gnosis-guild/eth-sdk";

export default defineConfig({
  contracts: {
    mainnet: {
      dai: "0x6b175474e89094c44da98b954eedeac495271d0f",
      usdc: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
      lagoon: {
        vault: "0x16648324d68B86E341051767e749F9F074714228", // implementation
      },
      curve: {
        crvUSD: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E",
        scrvUSD: "0x0655977FEb2f289A4aB78af67BAB0d17aAb84367",
        stableSwapNg: "0xc522A6606BBA746d7960404F22a3DB936B6F4F50",
      },
      resupply: {
        pair: "0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D",
      },
      convex: {
        booster: "0xf403c135812408bfbe8713b5a23a04b3d48aae31",
        baseRewardPool: "0x7Fafc1876970dBD9F6568586EFa7d0FAc0FE8EA8",
      },
      bridge: {
        stargate: {
          simpleOFTAdapter: "0xC4543073Bfaba77781B46dfb4D43b5Ae4e30Eb28", //implementation
        },
      },
    },
    base: {
      pendle: {
        ActionAddRemoveLiqV3: "0x663C21103915B68e9dA797CfdF3cAb01a037D5Ff",//contain function needed
      },
      bridge: {
        stargate: {
          simpleOFT: "0x2492d0006411af6c8bbb1c8afc1b0197350a79e9",
        },
      },
    },
    base: {
      bridge: {
        stargate: {
          simpleOFA: "0x2492d0006411af6c8bbb1c8afc1b0197350a79e9", //implementation
        }
      }
    },
  },
});
