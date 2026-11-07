{
	Init[ (s)
	{
		SetName(1262);
		SetLevel(4);
		SetExpWorth(200);
		SetLevel(4);
		SetAggressive(true);
		SetAttack(4);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(7);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(12);
		SetDeathNoise(31);
		SetIsHitNoise(14);

		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetUndead(true);
		SetLoot(300, "Loot_Gold5-15", 1, 3 );
		SetMob(1);
	} ]

	OnKilled[ (s)
	{
		GetPlayer().AddMonsterKilled(66);
		if (GetPlayer().MonstersKilled(66) > 2)
		{
			GetPlayer().SetQuestSolved(49);
		}
	}]
}