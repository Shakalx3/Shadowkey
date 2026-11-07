{
	Init[ (s)
	{
		SetName(1821);
		SetExpWorth(400);
		SetLevel(9);
		SetSkin(5);

		SetAggressive(true);
		SetAttack(3);
		SetDefense(9);
		SetSpellcast(10);
		SetMagicResistance(10);
		SetDamageMin(0);
		SetDamageMax(0);
		SetArmorValue(4);
		SetMaxHealth(35);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(6);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(3);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttackRange(12000);
		SetPlaySpellCasting(true);
		SetLoot( 300, "Loot_2MagickaPotion", 1, 2 );
		Item = Level.CreateEntity( 4024 ); //ignite
		AddSpell( Item, 20 );
		Item = Level.CreateEntity( 4021 ); //feeble
		AddSpell( Item, 40 );
		Item = Level.CreateEntity( 50 ); //blaze
		AddSpell( Item, 100 );

		SetMob(2);
	} ]
}
