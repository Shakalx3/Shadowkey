{
	Init[ (s)
	{
		SetName(459);
		SetExpWorth(0);
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
		SetUseText(460);
		SetUsable(true);
		SetInvulnerable(true);

		SetAttachedWeapon(224);
	} ]

	OnUse[()
	{
		OpenMenu("broken1\\\\makor_temp_convo");
		GetPlayer().saved_Makor = 1;
	}]

	OnHit[()
	{
		GetPlayer().saved_Makor = 1;
	}]
}
