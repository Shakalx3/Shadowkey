{
	Init[ (s)
	{
		SetName(2102);
		SetSkin(5);
		SetExpWorth(0);
		SetAggressive(false);
		SetLevel(0);
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
		PlayAnimationOffset(0);
		SetUseText(2103);
		SetUsable(true);
		SetInvulnerable(true);

	} ]

	OnUse[()
	{
		OpenMenu("broken1\\\\meya_convo");
	}]
}
