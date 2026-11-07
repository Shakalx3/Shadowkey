{
	Init[ (s)
	{
		SetName(1821);
		SetExpWorth(300);
		SetAggressive(true);
		SetAttack(3);
		SetDefense(6);
		SetSpellcast(5);
		SetMagicResistance(5);
		SetDamageMin(2);
		SetDamageMax(6);
		SetArmorValue(2);
		SetMaxHealth(30);
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
		SetSkin(5);
		SetPlaySpellCasting(true);

		//add blaze and blind spells
		Item = Level.CreateEntity( 50 );
		AddSpell( Item, 50 );
		Item.SetLevel(5);
		Item = Level.CreateEntity( 4010 );
		AddSpell( Item, 50 );
		Item.SetLevel(10);

		SetLoot(300, "lakvan\\\\loot_1");
		SetMob(2);
	} ]

}
