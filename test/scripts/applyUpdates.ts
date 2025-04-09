import { Address } from "@gnosis-guild/eth-sdk";
import { applyMembers, applyTargets, ChainId, fetchRolesMod, processPermissions, Role, Target } from "zodiac-roles-sdk";
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

export async function exportCalls(calls: `0x${string}`[], filePath: string = 'test/data/permissions.json') {
  await Bun.write(filePath, JSON.stringify(calls, null, 2));
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

const permissions = [
  ... await kit.lagoon.settleDeposit({ targets: ['0x07ed467acd4ffd13023046968b0859781cb90d9b'] }),
  ... await kit.lagoon.settleRedeem({ targets: ['0x07ed467acd4ffd13023046968b0859781cb90d9b'] })
];


const { targets } = processPermissions(permissions);


const calls = (await applyUpdates({
  chainId: 1,
  address: "0xc128B1307128e8A692c98DD48cd7Ff155521A093",
  owner: AVATAR,
  role: currentRole,
  members: [MANAGER],
  targets: targets,
})).map((call) => call.data)


await exportCalls(calls, 'test/protocols/lagoon/settle_deposit.json')
