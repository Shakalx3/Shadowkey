{
	Agro [0]
	Init[ (s)
	{
		SetName(945);
		SetSkin(0);
		SetExpWorth(240);
		SetAggressive(true);
		SetAttack(7);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(18);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(5);
		SetChaseRadius(18000);

		SetAttackNoise(3);
		SetDeathNoise(4);
		SetIsHitNoise(5);

		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(8);
		SetAttachedWeapon(222);
		SetLoot(300, "Loot_Gold25-35Healing", 1, 4 );
		SetMob(1);
	} ]

	OnKilled [ (s)
	{
		GetPlayer().OpenMenu("Raiders\\\\Loot5");
	}]
}