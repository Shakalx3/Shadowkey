{
	Init[ (s)
	{
		SetName(722);
		SetExpWorth(180);
		SetLevel(3);
		SetAggressive(true);
		SetAttack(5);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(3);
		SetDamageMax(8);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttackRange(12000);
		SetLoot(300, "Loot_Gold12-19Healing", 1, 4 );
		SetAttachedWeapon( 223 );

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
