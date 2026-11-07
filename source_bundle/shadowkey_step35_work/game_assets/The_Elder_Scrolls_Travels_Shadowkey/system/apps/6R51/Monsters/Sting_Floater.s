{
	Init[ (s)
	{
		SetName(2136);
		SetExpWorth(440);
		SetLevel(10);
		SetAggressive(true);
		SetAttack(10);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(7);
		SetDamageMin(4);
		SetDamageMax(36);
		SetArmorValue(2);
		SetMaxHealth(65);
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
		Item = Level.CreateEntity( 4034 ); //poison
		Item.SetLevel(8);
		AddSpell( Item );
		SetMeleeRoll(75);

		SetMob(3);
	} ]
}
