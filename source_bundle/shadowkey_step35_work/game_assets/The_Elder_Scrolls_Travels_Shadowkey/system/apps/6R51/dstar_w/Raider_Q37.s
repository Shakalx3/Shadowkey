{
	Init[ (s)
	{
		SetName(945);
		SetSkin(2);
		SetExpWorth(240);
		SetAggressive(true);
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

		SetAttachedWeapon( 226 );
		SetLoot(300, "Loot_Gold25-35Healing", 1, 4 );
		SetMob(1);
	} ]

	OnKilled[ (s)
	{
		Level.saved_RaidersQ37 = Level.saved_RaidersQ37 + 1;
		if (Level.saved_RaidersQ37 > 11)
		{
			if(Level.saved_skyrim_convo = 0)
			{
				GetPlayer().SetQuestSolved(37);
				GetPlayer().OpenMenu("dstar_w\\\\skyrim_convo");
			}
		}
	}]
}