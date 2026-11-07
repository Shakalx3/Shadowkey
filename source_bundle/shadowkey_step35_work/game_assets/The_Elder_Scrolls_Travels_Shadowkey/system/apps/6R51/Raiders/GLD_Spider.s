{
	Init[ (s)
	{
		SetSkin(1);
		SetName(2133);
		SetExpWorth(280);
		SetLevel(6);
		SetAttack(8);
		SetDefense(3);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(10);
		SetArmorValue(2);
		SetMaxHealth(55);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(15);
		SetDeathNoise(16);
		SetIsHitNoise(17);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
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
