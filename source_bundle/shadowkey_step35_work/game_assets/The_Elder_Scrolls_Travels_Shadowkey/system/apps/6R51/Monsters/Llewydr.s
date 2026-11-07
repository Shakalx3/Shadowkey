{
	Init[ (s)
	{
		SetName(2097);
		SetSkin(7);
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

		SetWalkAnimation(0);
		SetSwingAnimation(0);
		SetDeathAnimation(0);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);

		SetUsable(true);
		SetUseText(2098);

		SetInvulnerable(true);

		ClearProducts();
		AddProduct(4021, "Feeble Blade", 1790, 1, IPT_Spell);
		AddProduct(4025, "Paralyze", 2200, 1, IPT_Spell);
	} ]

	OnUse[ (s)
	{
		GetPlayer().SetMerchant(self);
		OpenMenu("snowline\\\\LlewydrConvo");
	} ]
}
