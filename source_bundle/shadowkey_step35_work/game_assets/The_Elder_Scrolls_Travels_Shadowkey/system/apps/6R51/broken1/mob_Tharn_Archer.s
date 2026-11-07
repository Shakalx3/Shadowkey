{

	Init[ (s)
	{
		SetName(499);
		SetExpWorth(640);
		SetLevel(15);
		SetAggressive(false);
		SetAttack(17);
		SetDefense(6);
		SetSpellcast(0);
		SetMagicResistance(12);
		SetDamageMin(1);
		SetDamageMax(42);
		SetArmorValue(4);
		SetMaxHealth(50);
		SetWimpy(5);
		SetChaseRadius(18000);

		SetAttackNoise(1);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetWalkAnimation(5);
		SetSwingAnimation(2);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(0);
		SetAttackRange(12000);

		SetAttachedWeapon(225);
		SetLoot(300, "Loot_DoubleBow", 1, 6 );

		SetSkin(4);
		SetMob(4);
	}]

	OnHit[ ()
	{
		Tharn1 = Level.GetEntity("Tharn1");
		if( isObject( Tharn1 ) )
		{
			Tharn1.SetAggressive(true);
		}

		Tharn2 = Level.GetEntity("Tharn2");
		if( isObject( Tharn2 ) )
		{
			Tharn2.SetAggressive(true);
		}

		Tharn3 = Level.GetEntity("Tharn3");
		if( isObject( Tharn3 ) )
		{
			Tharn3.SetAggressive(true);
		}
	}]
}