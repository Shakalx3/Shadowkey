{
	Init[ (s)
	{
		SetName(2119);
		SetExpWorth(560);
		SetLevel(13);
		SetSkin(1);

		SetAggressive(true);
		SetAttack(11);
		SetDefense(9);
		SetSpellcast(0);
		SetMagicResistance(13);
		SetDamageMin(4);
		SetDamageMax(36);
		SetArmorValue(2);
		SetMaxHealth(50);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(39);
		SetDeathNoise(40);
		SetIsHitNoise(41);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);

		Item = Level.CreateEntity( 4010 ); //blind
		Item.SetLevel(10);
		AddSpell( Item );

		SetMeleeRoll(60);

		SetMob(3);
	} ]
}
