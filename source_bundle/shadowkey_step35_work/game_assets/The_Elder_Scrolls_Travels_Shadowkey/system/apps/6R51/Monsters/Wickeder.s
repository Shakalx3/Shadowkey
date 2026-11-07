{
	Init[ (s)
	{
		SetName(2151);
		SetExpWorth(280);
		SetLevel(6);
		SetSkin(0);
		SetAttackRange(3000);
		SetAggressive(true);
		SetAttack(8);
		SetDefense(3);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(1);
		SetDamageMax(20);
		SetArmorValue(2);
		SetMaxHealth(70);
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
		SetScale(192);
		SetLoot(300, "Loot_Wickeder_Skin", 1, 6 );
		Item = Level.CreateEntity( 4025 ); //paralyze
		Item.SetLevel(2);
		AddSpell( Item );

		SetMeleeRoll(70);

		SetMob(3);
	} ]
}
