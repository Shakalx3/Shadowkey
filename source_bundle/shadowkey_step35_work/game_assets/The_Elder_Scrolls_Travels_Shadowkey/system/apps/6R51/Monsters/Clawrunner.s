{
	Init[ (s)
	{
		SetName(2044);
		SetExpWorth(520);
		SetLevel(12);
		SetSkin(2);
		SetAttackRange(3000);
		SetMeleeAttackRange(2000);
		SetAggressive(true);
		SetAttack(12);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(5);
		SetDamageMin(1);
		SetDamageMax(32);
		SetArmorValue(4);
		SetMaxHealth(80);
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
		SetPlaySpellCasting(true);
		SetLoot( 300, "loot_cskin", 1, 6 );
		Item = Level.CreateEntity( 4025 ); //paralyze
		Item.SetLevel(2);
		AddSpell( Item );

		SetMeleeRoll(70);
		SetScale(192);

		SetMob(3);
	} ]
}
