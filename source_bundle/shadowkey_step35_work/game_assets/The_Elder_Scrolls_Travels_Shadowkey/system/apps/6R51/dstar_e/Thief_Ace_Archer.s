{
	Init[ (s)
	{
		SetName(942);
		SetExpWorth(300);
		SetLevel(6);
		SetAggressive(false);
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
		SetAttachedWeapon( 225 );
		SetLoot(300, "Loot_DoubleBow", 1, 6 );
		SetMob(4);
	}]

	OnDetect[ (s)
	{
		if(Level.saved_TheifTrap = 1 )
		{
			SetAggressive(true);
		}
	}]

	OnHit[ (s)
	{
		Level.saved_TheifTrap = 1;
	}]
}
