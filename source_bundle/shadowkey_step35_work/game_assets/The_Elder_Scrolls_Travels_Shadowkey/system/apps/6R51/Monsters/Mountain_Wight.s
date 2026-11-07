{
	Init[ (s)
	{
		SetName(2105);
		SetExpWorth(280);
		SetLevel(6);
		SetSkin(0);
		SetAggressive(true);
		SetAttack(8);
		SetDefense(4);
		SetSpellcast(5);
		SetMagicResistance(8);
		SetDamageMin(4);
		SetDamageMax(10);
		SetArmorValue(1);
		SetMaxHealth(38);
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
		SetLoot( 300, "loot_gold25-35Magicka", 1, 6);
		Item = Level.CreateEntity( 4009 );
		Item.SetLevel(4);
		AddSpell( Item );
		SetMeleeRoll(75);
		SetMob(3);
	} ]
}
