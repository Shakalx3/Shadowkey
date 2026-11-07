{
	Init[ (s)
	{
		SetName(942);
		SetExpWorth(300);
		SetLevel(6);
		SetSkin(8);
		SetAggressive(true);
		SetAttack(9);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(24);
		SetArmorValue(1);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(18000);

		SetAttackNoise(1);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetWalkAnimation(5);
		SetSwingAnimation(2);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetLoot(300, "Loot_DoubleBow", 1, 4 );
		SetAttachedWeapon( 225 );
		SetMob(4);
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