{
	Init[ (s)
	{
		SetName(2124);
		SetSkin(0);
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

		SetWalkAnimation(4);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		PlayAnimationOffset(8);
		SetIdleAnimation(8);
		SetInvulnerable(true);
		SetUsable(true);
		SetUseText(2125);
	} ]

	OnUse[ (s)
	{
		OpenMenu("snowline\\\\SisithikConvo");
	} ]
}
