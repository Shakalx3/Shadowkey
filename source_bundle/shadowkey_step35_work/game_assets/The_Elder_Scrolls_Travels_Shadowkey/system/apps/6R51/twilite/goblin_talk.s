{
	saved_aggro[0]

	Init[ (s)
	{
		if (saved_aggro = 0)
		{
			SetAggressive(false);
			SetInvulnerable(true);
			SetUseText(2623);
			SetUsable(true);
		}

		SetName(2623);
		SetExpWorth(160);
		SetAttack(4);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(6);
		SetDamageMin(3);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		PlayAnimation(0);
		SetMob(1);
	} ]

	OnUse[ (s)
	{
		OpenMenu("twilite\\\\goblin_convo");
	}]

	OnHit[ (s)
	{
		SetAggressive(true);
		SetInvulnerable(false);
		SetUsable(false);
		GetPlayer().saved_Goblin = 1;
		saved_aggro=1;
	}]
	OnDecay[ (s)
	{
		GetPlayer().SetQuestCompleted(18);
	}]
}