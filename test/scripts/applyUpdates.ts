import { Address } from "@gnosis-guild/eth-sdk";
import { applyMembers, applyTargets, c, ChainId, fetchRolesMod, Permission, processPermissions, Role, Target } from "zodiac-roles-sdk";
import { kit } from "../../dist/eth";

interface ApplyUpdates {
  chainId: ChainId,
  address: Address,
  owner: Address,
  role: Role,
  members: Address[],
  targets: Target[],
}

export async function applyUpdates({
  chainId,
  address,
  role,
  members,
  targets,
}: ApplyUpdates) {

  const comments: string[] = []
  const logCall = (log: string) => comments.push(log)

  let calls: { to: `0x${string}`; data: `0x${string}` }[] = []

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
    )
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
    )
  }

  return calls;
}

const MANAGER = '0xA5d55E7A556fbA22974479497E6bf7e097D81b5e'

const TEST_ROLE = '0x544553542d524f4c450000000000000000000000000000000000000000000000'

const AVATAR = '0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f'

const currentRole: Role = {
  key: TEST_ROLE,
  members: [MANAGER],
  targets: [],
  annotations: [],
  lastUpdate: 0
}

async function getCallsFromPermissions(permissions: Permission[]) {
  const { targets } = processPermissions(permissions);

  return (await applyUpdates({
    chainId: 1,
    address: "0xc128B1307128e8A692c98DD48cd7Ff155521A093",
    owner: AVATAR,
    role: currentRole,
    members: [MANAGER],
    targets: targets,
  })).map((call) => call.data)

}

const permissions = {
  lagoon: {
    manageVault: await kit.lagoon.manageVault(
      {
        targets:
          [
            {
              vault: '0x07ed467acd4ffd13023046968b0859781cb90d9b',
              rates: { managementRate: c.eq(42), performanceRate: c.eq(42) },
              canClaimSharesOnBehalf: true
            }
          ]
      }
    ),
    settleVault: await kit.lagoon.settleVault({ targets: ['0x07ed467acd4ffd13023046968b0859781cb90d9b'] }),
    closeVault: await kit.lagoon.closeVault({ targets: ['0x07ed467acd4ffd13023046968b0859781cb90d9b'] })
  },
  resupply: {
    deposit: await kit.resupply.deposit({ targets: ['0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D'] }),
    borrow: await kit.resupply.borrow({ targets: ['0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D'] }),
    depositAndBorrow: await kit.resupply.depositAndBorrow({ targets: ['0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D'] })
  }
}


type Protocol = keyof typeof kit
type Action = keyof typeof kit[Protocol]

const protocols = Object.keys(kit) as Protocol[];

const calls = await protocols.reduce(async (accP, protocol) => {
  const acc = await accP;
  acc[protocol] = {} as Record<Action, `0x${string}`[]>;

  const actions = Object.keys(kit[protocol]) as Action[];

  await Promise.all(actions.map(async (action) => {
    acc[protocol][action] = await getCallsFromPermissions(permissions[protocol][action]);
  }));

  return acc;
}, Promise.resolve({} as Record<Protocol, Record<Action, `0x${string}`[]>>));


await Bun.write('test/data/permissions.json', JSON.stringify(calls, null, 2));
