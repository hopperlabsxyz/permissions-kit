import { Address } from "@gnosis-guild/eth-sdk";
import {
  applyMembers,
  applyTargets,
  c,
  ChainId,
  Permission,
  processPermissions,
  Role,
  Target,
} from "zodiac-roles-sdk";
import { kit } from "../../dist/eth";

interface ApplyUpdates {
  chainId: ChainId;
  address: Address;
  owner: Address;
  role: Role;
  members: Address[];
  targets: Target[];
}

export async function applyUpdates({
  chainId,
  address,
  role,
  members,
  targets,
}: ApplyUpdates) {
  const comments: string[] = [];
  const logCall = (log: string) => comments.push(log);

  let calls: { to: `0x${string}`; data: `0x${string}` }[] = [];

  if (members) {
    calls = calls.concat(
      (
        await applyMembers(role.key, members, {
          chainId,
          address,
          mode: "replace",
          currentMembers: role.members,
          log: logCall,
        })
      ).map((data) => ({ to: address, data }))
    );
  }

  if (targets) {
    calls = calls.concat(
      (
        await applyTargets(role.key, targets, {
          chainId,
          address,
          mode: "replace",
          currentTargets: role.targets,
          log: logCall,
        })
      ).map((data) => ({ to: address, data }))
    );
  }

  return calls;
}

const MANAGER = "0xA5d55E7A556fbA22974479497E6bf7e097D81b5e";

const TEST_ROLE =
  "0x544553542d524f4c450000000000000000000000000000000000000000000000";

const AVATAR = "0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f";

const currentRole: Role = {
  key: TEST_ROLE,
  members: [MANAGER],
  targets: [],
  annotations: [],
  lastUpdate: 0,
};

async function getCallsFromPermissions(permissions: Permission[]) {
  const { targets } = processPermissions(permissions);

  return (
    await applyUpdates({
      chainId: 1,
      address: "0xc128B1307128e8A692c98DD48cd7Ff155521A093",
      owner: AVATAR,
      role: currentRole,
      members: [MANAGER],
      targets: targets,
    })
  ).map((call) => call.data);
}

const permissions = {
  lagoon: {
    manageVault: await kit.lagoon.manageVault({
      targets: [
        {
          vault: "0x07ed467acd4ffd13023046968b0859781cb90d9b",
          rates: { managementRate: c.eq(42), performanceRate: c.eq(42) },
          canClaimSharesOnBehalf: true,
        },
      ],
    }),
    settleVault: await kit.lagoon.settleVault({
      targets: ["0x07ed467acd4ffd13023046968b0859781cb90d9b"],
    }),
    closeVault: await kit.lagoon.closeVault({
      targets: ["0x07ed467acd4ffd13023046968b0859781cb90d9b"],
    }),
  },
  resupply: {
    deposit: await kit.resupply.deposit({
      targets: ["0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D"],
    }),
    borrow: await kit.resupply.borrow({
      targets: ["0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D"],
    }),
    depositAndBorrow: await kit.resupply.depositAndBorrow({
      targets: ["0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D"],
    }),
  },
  curve: {
    stakeCrvUSD: await kit.curve.stakeCrvUSD(),
    depositStableSwapNg: await kit.curve.depositStableSwapNg({
      targets: ["0xc522a6606bba746d7960404f22a3db936b6f4f50"],
    }),
  },
  convex: {
    deposit: await kit.convex.deposit({ targets: [440] }),
  },
  bridge: {
    stargate: {
      transfer: await kit.bridge.stargate.transfer({
        targets: [
          {
            tokenAddresses: ["0x66a1E37c9b0eAddca17d3662D6c05F4DECf3e110"],//USR eth
            dstChainIds: [30332],
            receiver: `0x000000000000000000000000${AVATAR.slice(2)}`,
          },
          //WIP base
          // {
          //   tokenAddresses: ["0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9"],// USR base
          //   dstChainIds: [30101],
          //   receiver: `0x000000000000000000000000${AVATAR.slice(2)}`,
          // }
        ],
      }),
    },
  },
};

const protocols = Object.keys(kit).filter((p) => p !== "bridge");

const calls = await protocols.reduce(async (accP, protocol) => {
  const acc: any = await accP;
  acc[protocol] = {};

  let actions = Object.keys((kit as any)[protocol]);

  await Promise.all(
    actions.map(async (action) => {
      acc[protocol][action] = await getCallsFromPermissions(
        (permissions as any)[protocol][action]
      );
    })
  );

  return acc;
}, Promise.resolve({}));

const bridgeProtocols = Object.keys(kit["bridge"]);

const bridgeCalls = await bridgeProtocols.reduce(async (accP, protocol) => {
  const acc: any = await accP;
  if (!acc["bridge"]) {
    acc["bridge"] = {};
  }
  acc["bridge"][protocol] = {};

  let actions = Object.keys((kit.bridge as any)[protocol]);

  await Promise.all(
    actions.map(async (action) => {
      acc["bridge"][protocol][action] = await getCallsFromPermissions(
        (permissions as any)["bridge"][protocol][action]
      );
    })
  );

  return acc;
}, calls);

await Bun.write(
  "test/data/permissions.json",
  JSON.stringify(bridgeCalls, null, 2)
);
