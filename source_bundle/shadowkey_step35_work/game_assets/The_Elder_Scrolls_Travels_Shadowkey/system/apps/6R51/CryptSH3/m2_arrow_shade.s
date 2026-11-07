{
	Init[()
	{
		SetAggressive(true);
		SetName(693);
		SetExpWorth(760);
		SetLevel(18);
		SetAttack(18);
		SetDefense(7);
		SetSpellcast(0);
		SetMagicResistance(14);
		SetDamageMin(1);
		SetDamageMax(50);
		SetArmorValue(4);
		SetMaxHealth(60);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(1);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(2);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(0);
		SetSkin(5);
		SetAttackRange(12000);
		SetAttachedWeapon(225);
		SetMob(1, 1);
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