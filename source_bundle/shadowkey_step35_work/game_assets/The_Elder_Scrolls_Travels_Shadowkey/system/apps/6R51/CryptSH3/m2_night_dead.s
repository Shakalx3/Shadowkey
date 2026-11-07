{
	Init[()
	{
		SetName(696);
		SetExpWorth(0);
		SetLevel(8);
		SetAggressive(true);
		SetAttack(5);
		SetDefense(6);
		SetSpellcast(0);
		SetMagicResistance(5);
		SetDamageMin(6);
		SetDamageMax(10);
		SetArmorValue(3);
		SetMaxHealth(40);
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
		SetLoot(300, "Loot_MagickaPotion", 1, 4 );
		SetMob(1);
	}]
	OnKilled[()
	{
		Forge = Level.saved_Forge;
		Forge = Forge + 1;
		if (Forge = 4)
		{
			GetPlayer().OpenMenu("cryptsh3\\\\umbra_hero_forge_menu");
			Forge = 0;
		}
		Level.saved_Forge = Forge;
	}]
}