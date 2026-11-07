{
	Init[ (s)
	{
		SetName(2126);
		SetID("skelos");
		SetExpWorth(0);
		SetSkin(9);
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

		SetWalkAnimation(0);
		SetSwingAnimation(0);
		SetDeathAnimation(0);
		SetIdleAnimation(0);
		PlayAnimationOffset(8);

		SetInvulnerable(true);
		SetUseText(2126);
		SetUsable(true);
	} ]

	OnUse[ (s)
	{
		OpenMenu("AzraSkelosConvo");
	} ]

	SummonMe[()
	{
		SetPosition(29379, 6260, -2816);
	}]
}
