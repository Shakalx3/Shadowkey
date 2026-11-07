{
	Init[ (s)
	{
		SetName(3116);
		SetSkin(1);
		SetInvulnerable(true);
		SetExpWorth(0);
		SetLevel(0);

		SetAggressive(false);
		SetAttack(0);
		SetDefense(0);
		SetSpellcast(0);
		SetMagicResistance(0);
		SetDamageMin(0);
		SetDamageMax(0);
		SetArmorValue(0);
		SetMaxHealth(0);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(2);
		SetDeathNoise(3);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(7);
		PlayAnimationOffset(8);
		SetUsable(true);
		SetUseText(3116);
	} ]

	OnUse[ (s)
	{
		OpenMenu("dstar_e\\\\HQ_menu");
	} ]
}
