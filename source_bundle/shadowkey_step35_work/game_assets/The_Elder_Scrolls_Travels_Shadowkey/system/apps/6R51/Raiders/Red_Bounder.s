{
	Init[ (s)
	{
		SetName(2116);
		SetExpWorth(360);
		SetLevel(8);
		SetAttack(9);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(4);
		SetDamageMin(1);
		SetDamageMax(26);
		SetArmorValue(2);
		SetMaxHealth(70);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(12);
		SetDeathNoise(31);
		SetIsHitNoise(14);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(1);
		PlayAnimationOffset(0);
		SetScale(192);

		SetLoot( 300, "loot_sbskin", 1, 6 );
		Item = Level.CreateEntity( 4025 ); //paralyze
		Item.SetLevel(4);
		AddSpell( Item );

		SetMeleeRoll(70);
		SetMob(3);
		SetAlwaysOnDetect(true);

	}]
	OnDetect[ (s)
	{
		if(GetPlayer().HasAmulet("redam") = true)
		{
			SetAggressive(false);
		}
		else
		{
			SetAggressive(true);
		}
	}]
}