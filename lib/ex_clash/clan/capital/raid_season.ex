defmodule ExClash.Clan.Capital.RaidSeason do
  
    # {
    #   "capitalTotalLoot": 178644,
    #   "defensiveReward": 0,
    #   "startTime": "20240607T070000.000Z",
    #   "endTime": "20240610T070000.000Z",
    #   "enemyDistrictsDestroyed": 17,
    #   "offensiveReward": 0,
    #   "raidsCompleted": 2,
    #   "state": "ongoing",
    #   "totalAttacks": 42,
    #   "attackLog": [ ],
    #   "defenseLog": [ ],
    #   "members": [ ]
    # }

  defstruct [
    :capital_total_loot,
    :defensive_reward,
    :start_time,
    :end_time,
    :enemy_districts_destroyed,
    :offensive_reward,
    :state,
    :total_attacks,
    :attack_log,
    :defense_log,
    :members,
  ]
end
