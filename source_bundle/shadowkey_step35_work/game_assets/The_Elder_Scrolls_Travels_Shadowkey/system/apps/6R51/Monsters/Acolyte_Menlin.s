{
	Init[ (s)
	{
		SetName(1969);
		SetExpWorth(0);
		SetLevel(0);
		SetSkin(5);
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

		SetWalkAnimation(0);
		SetSwingAnimation(0);
		SetDeathAnimation(0);
		SetIdleAnimation(0);
		PlayAnimationOffset(7);

		SetInvulnerable( true );
		SetUseText(2027);
	} ]


	OnUse[ (s)
	{
		OpenMenu("MenlinConvo");
	} ]
}
