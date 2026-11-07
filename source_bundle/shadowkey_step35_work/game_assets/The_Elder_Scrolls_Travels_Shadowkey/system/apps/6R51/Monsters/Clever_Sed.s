{
	Init[ (s)
	{
		SetName(2046);
		SetSkin(10);
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

		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);
		SetUsable(true);
		SetUseText(2046);
		SetInvulnerable(true);
		SetAttachedWeapon(224);
	}]

	OnUse[ ()
	{
		OpenMenu("dstar_e\\\\clever_convo");
	}]
}
