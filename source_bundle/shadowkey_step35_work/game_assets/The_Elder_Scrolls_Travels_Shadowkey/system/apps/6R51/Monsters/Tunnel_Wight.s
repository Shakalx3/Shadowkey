{
	Init[ (s)
	{
		SetName(2143);
		SetExpWorth(400);
		SetLevel(9);
		SetSkin(1);

		SetAggressive(true);
		SetAttack(9);
		SetDefense(8);
		SetSpellcast(5);
		SetMagicResistance(6);
		SetDamageMin(4);
		SetDamageMax(22);
		SetArmorValue(1);
		SetMaxHealth(46);
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
		SetUndead(true);

		Item = Level.CreateEntity( 4008 ); //weakness
		Item.SetLevel(9);
		AddSpell( Item, 30 ); //30%
		Item = Level.CreateEntity( 4009 ); //absorb
		Item.SetLevel(7);
		AddSpell( Item, 70 ); //40% of the time
		Item = Level.CreateEntity( 4023 ); //harm armor
		Item.SetLevel(9);
		AddSpell( Item, 100 ); //30%
		SetMeleeRoll(50);

		SetMob(3);
	} ]
}
