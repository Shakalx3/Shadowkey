{
	Init[ (s)
	{
		SetName(2121);
		SetExpWorth(700);
		SetLevel(15);
		SetAggressive(true);
		SetAttack(14);
		SetDefense(10);
		SetSpellcast(0);
		SetMagicResistance(10);
		SetDamageMin(4);
		SetDamageMax(36);
		SetArmorValue(2);
		SetMaxHealth(65);
		SetChaseRadius(18000);

		SetAttackNoise(15);
		SetDeathNoise(16);
		SetIsHitNoise(17);

		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetSkin(3);

		Item = Level.CreateEntity( 4023 );
		Item.SetLevel(10);
		AddSpell( Item, 20 );
		Item = Level.CreateEntity( 4018 );
		Item.SetLevel(10);
		AddSpell( Item, 60 );
		Item = Level.CreateEntity( 4021 );
		Item.SetLevel(10);
		AddSpell( Item, 100 );

		SetMeleeRoll(50);

		SetMob(3);
	} ]
}
