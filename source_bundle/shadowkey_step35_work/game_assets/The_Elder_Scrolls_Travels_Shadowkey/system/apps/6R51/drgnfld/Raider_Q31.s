{
	Init[ (s)
	{
		SetName(945);
		SetSkin(0);
		SetExpWorth(240);
		SetAggressive(false);
		SetAttack(7);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(18);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(5);
		SetChaseRadius(18000);

		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttachedWeapon(222);
		SetLoot(300, "Loot_Gold25-35Healing", 1, 4 );
		SetMob(1);
	} ]

	OnKilled[()
	{
		GetPlayer().AddMonsterKilled(101);
		if (GetPlayer().MonstersKilled(101) >= 7)
		{
			GetPlayer().SetQuestSolved(31);
		}
	}]
}