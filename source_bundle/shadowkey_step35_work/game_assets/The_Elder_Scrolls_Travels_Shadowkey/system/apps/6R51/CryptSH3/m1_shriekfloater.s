{
	Init[()
	{
		SetName(694);
		SetExpWorth(560);
		SetLevel(12);
		SetAggressive(true);
		SetAttack(12);
		SetDefense(8);
		SetSpellcast(0);
		SetMagicResistance(8);
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
		SetSkin(2);
		SetLoot(300, "Loot_Floater_Sac", 1, 6 );
		Item = Level.CreateEntity( 4033 ); //disease
		Item.SetLevel(7);
		AddSpell( Item );
		SetMeleeRoll(75);
		SetMob(2, 2);
	}]

	OnKilled[()
	{
		Awaits = Level.saved_Awaits;
		Awaits = Awaits + 1;
		if (Awaits = 4)
		{
			GetPlayer().OpenMenu("cryptsh3\\\\umbra_awaits_menu");
			Awaits = 0;
		}
		Level.saved_Awaits = Awaits;
	}]
}