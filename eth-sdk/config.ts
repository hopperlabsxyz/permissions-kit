import { defineConfig } from "@gnosis-guild/eth-sdk";

export const contracts = {
  mainnet: {
    weth: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
    dai: '0x6b175474e89094c44da98b954eedeac495271d0f',
    usdc: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
    lagoon: {
      vault: '0xE50554ec802375C9c3F9c087a8a7bb8C26d3DEDf', // implementation
    },
    curve: {
      crvUSD: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E",
      scrvUSD: "0x0655977FEb2f289A4aB78af67BAB0d17aAb84367",
      stableSwapNg: "0xc522A6606BBA746d7960404F22a3DB936B6F4F50",
      gauge: "0x92219862F9F40fe27444e45a9554E824e8556A62",
    },
    resupply: {
      pair: "0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D",
    },
    convex: {
      booster: "0xf403c135812408bfbe8713b5a23a04b3d48aae31",
      baseRewardPool: "0x7Fafc1876970dBD9F6568586EFa7d0FAc0FE8EA8",
    },
    lido: {
      stEth: "0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84",
      wstEth: "0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0",
      unstEth: "0x889edC2eDab5f40e902b864aD4d7AdE8E412F9B1",
    },
    etherfi: {
      depositAdapter: "0xe87797a1afb329216811dfa22c87380128ca17d8" // implementation
    },
    se7enseas: {
      boringVault: "0x294eecec65A0142e84AEdfD8eB2FBEA8c9a9fbad",
      teller: "0xe97365b41B340352d3d32CA2C7230330F19A1e73",
    },
    bridge: {
      stargate: {
        simpleOFTAdapter: "0xC4543073Bfaba77781B46dfb4D43b5Ae4e30Eb28", //implementation
      },
      canonical: {
        l1ChugSplashProxy: "0x0b09ba359A106C9ea3b181CBc5F394570c7d2a7A", // implemnetation
      },
    },
  },
  base: {
    pendle: {
      ActionAddRemoveLiqV3: "0x663C21103915B68e9dA797CfdF3cAb01a037D5Ff", //contain function needed
    },
    bridge: {
      stargate: {
        simpleOFT: "0x2492d0006411af6c8bbb1c8afc1b0197350a79e9",
      },
    },
  },
} as const;

export default defineConfig({
  contracts,
});
