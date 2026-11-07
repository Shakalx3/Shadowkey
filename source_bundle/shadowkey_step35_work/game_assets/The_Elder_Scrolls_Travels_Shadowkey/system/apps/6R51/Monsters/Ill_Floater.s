{
	Init[ (s)
	{
		SetName(2094);
		SetExpWorth(400);
		SetLevel(8);
		SetSkin(0);

		SetAggressive(true);
		SetAttack(7);
		SetDefense(6);
		SetSpellcast(0);
		SetMagicResistance(6);
		SetDamageMin(4);
		SetDamageMax(32);
		SetArmorValue(2);
		SetMaxHealth(60);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(15);
		SetDeathNoise(16);
		SetIsHitNoise(17);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetLoot(300, "Loot_Floater_Sac", 1, 8 );
		Item = Level.CreateEntity( 4033 ); //disease
		Item.SetLevel(5);
		AddSpell( Item );

		SetMeleeRoll(75);

		SetMob(3);
	} ]
}
