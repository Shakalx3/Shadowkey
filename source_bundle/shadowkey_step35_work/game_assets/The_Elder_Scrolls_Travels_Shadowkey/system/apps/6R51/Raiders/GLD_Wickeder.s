{
	Init[ (s)
	{
		SetName(2151);
		SetExpWorth(280);
		SetLevel(6);
		SetAttack(8);
		SetDefense(3);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(1);
		SetDamageMax(20);
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
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetScale(192);
		SetLoot(300, "Loot_Wickeder_Skin", 1, 5 );
		Item = Level.CreateEntity( 4025 ); //paralyze
		Item.SetLevel(5);
		AddSpell( Item );
		SetMeleeRoll(70);
		SetMob(3);
		SetAlwaysOnDetect(true);

	}]
	OnDetect[ (s)
	{
		if(GetPlayer().HasAmulet("goldam") = true)
		{
			SetAggressive(false);
		}
		else
		{
			SetAggressive(true);
		}
	}]
}
