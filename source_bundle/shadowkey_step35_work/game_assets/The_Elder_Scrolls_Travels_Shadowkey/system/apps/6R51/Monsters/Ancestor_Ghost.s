{
	Init[ (s)
	{
		SetName(695);
		SetExpWorth(600);
		SetLevel(12);
		SetSkin(0);
		SetScale(256);
		SetAggressive(true);
		SetAttack(12);
		SetDefense(8);
		SetSpellcast(0);
		SetMagicResistance(9);
		SetDamageMin(4);
		SetDamageMax(40);
		SetArmorValue(2);
		SetMaxHealth(48);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(18);
		SetDeathNoise(19);
		SetIsHitNoise(20);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetLoot(300, "Loot_Gold30-80Vicar", 1, 4 );

		//add poison spell
		Spell = Level.CreateEntity( 4034 );
		Spell.SetLevel(10);
		AddSpell( Spell );

		SetMeleeRoll(75);

		SetMob(3);
	} ]
}
