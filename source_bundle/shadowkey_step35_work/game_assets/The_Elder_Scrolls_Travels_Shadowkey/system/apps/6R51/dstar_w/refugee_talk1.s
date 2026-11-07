{
	Init[ (s)
	{
		SetUseText(1199);
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
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);

		SetInvulnerable( true );
	} ]

	OnUse[ (s)
	{
		OpenMenu("dstar_w\\\\talk_menu1");
	} ]
}