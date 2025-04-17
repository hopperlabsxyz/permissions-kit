import { c } from "zodiac-roles-sdk/.";
//reUSD = "0x57aB1E0003F623289CD798B1824Be09a793e4Bec"
export default [
  // {
  //   name: "abc",
  //   address: "0xabc",
  //   underlying: "crvUSD or frxUSD", //collateralToken -> underlying
  //   loanToken: "reUSD",
  //   collateralVault: ""
  // },
  {
    name: "PAIR_CURVELEND_WETH_CRVUSD",
    address: "0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D",
    underlying: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E",// crvUSD
    collateralVault: "0x8fb1c7AEDcbBc1222325C39dd5c1D2d23420CAe3" //vault
  },
  // {
  //   name: "PAIR_CURVELEND_SFRXUSD_CRVUSD",
  //   address: "0xC5184cccf85b81EDdc661330acB3E41bd89F34A1",
  //   collateralToken: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E", //crvUSD underlying
  //   loanToken: "??", //crvUSD underlying
  //   collateralVault: ""
  // },
  // {
  //   name: "PAIR_CURVELEND_SDOLA_CRVUSD",
  //   address: "0x08064A8eEecf71203449228f3eaC65E462009fdF",
  //   collateralToken: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E", //crvUSD underlying
  //   loanToken: "????" //SDOLA ??
  // },
  // {
  //   name: "PAIR_CURVELEND_SUSDE_CRVUSD",
  //   address: "0x39Ea8e7f44E9303A7441b1E1a4F5731F1028505C",
  //   collateralToken: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E", //crvUSD underlying
  //   loanToken: "????" //SUSDE ??
  // },
  // {
  //   name: "PAIR_CURVELEND_USDE_CRVUSD",
  //   address: "0x3b037329Ff77B5863e6a3c844AD2a7506ABe5706",
  //   collateralToken: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E", //crvUSD underlying
  //   loanToken: "????" //USDE ??
  // },
  // {
  //   name: "PAIR_CURVELEND_TBTC_CRVUSD_DEPRECATED",
  //   address: "0x22B12110f1479d5D6Fd53D0dA35482371fEB3c7e",
  //   collateralToken: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E", //crvUSD underlying
  //   loanToken: "????" //TBTC ??
  // },
  // {
  //   name: "PAIR_CURVELEND_WBTC_CRVUSD",
  //   address: "0x2d8ecd48b58e53972dBC54d8d0414002B41Abc9D",
  //   collateralToken: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E", //crvUSD underlying
  //   loanToken: "????" //WBTC ??
  // },
  // {
  //   name: "PAIR_CURVELEND_WSTETH_CRVUSD",
  //   address: "0x4A7c64932d1ef0b4a2d430ea10184e3B87095E33",
  //   collateralToken: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E", //crvUSD underlying
  //   loanToken: "????"
  // },
  // {
  //   name: "PAIR_FRAXLEND_SFRXETH_FRXUSD",
  //   address: "0x3F2b20b8E8Ce30bb52239d3dFADf826eCFE6A5f7",
  //   collateralToken: "0xD9E1cE17f2641f24aE83637ab66a2cca9C378B9F", //frxETH
  //   loanToken: "??"
  // },
  // {
  //   name: "PAIR_FRAXLEND_SUSDE_FRXUSD",
  //   address: "0x212589B06EBBA4d89d9deFcc8DDc58D80E141EA0",
  //   collateralToken: "0xD4a138b6A6f9B2F8cE1C7d4A3e5Ff4E6E4D0cE6C", //frxUSD
  //   loanToken: "??"
  // },
  // {
  //   name: "PAIR_FRAXLEND_WBTC_FRXUSD_DEPRECATED",
  //   address: "0x55c49c707aA0Ad254F34a389a8dFd0d103894aDb",
  //   collateralToken: "0xD4a138b6A6f9B2F8cE1C7d4A3e5Ff4E6E4D0cE6C", //frxUSD
  //   loanToken: "??"
  // },
  // {
  //   name: "PAIR_FRAXLEND_WBTC_FRXUSD",
  //   address: "0xb5575Fe3d3b7877415A166001F67C2Df94D4e6c1",
  //   collateralToken: "0xD4a138b6A6f9B2F8cE1C7d4A3e5Ff4E6E4D0cE6C", //frxUSD
  //   loanToken: "??"
  // },
  // {
  //   name: "PAIR_FRAXLEND_SCRVUSD_FRXUSD",
  //   address: "0x24CCBd9130ec24945916095eC54e9acC7382c864",
  //   collateralToken: "0xD4a138b6A6f9B2F8cE1C7d4A3e5Ff4E6E4D0cE6C", //frxUSD
  //   loanToken: "??"
  // },


  // "PAIR_CURVELEND_SFRXUSD_CRVUSD": "0xC5184cccf85b81EDdc661330acB3E41bd89F34A1", ok
  // "PAIR_CURVELEND_SDOLA_CRVUSD": "0x08064A8eEecf71203449228f3eaC65E462009fdF", ok
  // "PAIR_CURVELEND_SUSDE_CRVUSD": "0x39Ea8e7f44E9303A7441b1E1a4F5731F1028505C", ok
  // "PAIR_CURVELEND_USDE_CRVUSD": "0x3b037329Ff77B5863e6a3c844AD2a7506ABe5706", ok
  // "PAIR_CURVELEND_TBTC_CRVUSD_DEPRECATED": "0x22B12110f1479d5D6Fd53D0dA35482371fEB3c7e", ok
  // "PAIR_CURVELEND_WBTC_CRVUSD": "0x2d8ecd48b58e53972dBC54d8d0414002B41Abc9D", ok
  // "PAIR_CURVELEND_WETH_CRVUSD": "0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D", ok
  // "PAIR_CURVELEND_WSTETH_CRVUSD": "0x4A7c64932d1ef0b4a2d430ea10184e3B87095E33", ok
  // "PAIR_FRAXLEND_SFRXETH_FRXUSD": "0x3F2b20b8E8Ce30bb52239d3dFADf826eCFE6A5f7", ok
  // "PAIR_FRAXLEND_SUSDE_FRXUSD": "0x212589B06EBBA4d89d9deFcc8DDc58D80E141EA0", ok
  // "PAIR_FRAXLEND_WBTC_FRXUSD_DEPRECATED": "0x55c49c707aA0Ad254F34a389a8dFd0d103894aDb", ok
  // "PAIR_FRAXLEND_WBTC_FRXUSD": "0xb5575Fe3d3b7877415A166001F67C2Df94D4e6c1", ok
  // "PAIR_FRAXLEND_SCRVUSD_FRXUSD": "0x24CCBd9130ec24945916095eC54e9acC7382c864", ok
] as const;
