{
	Init[ (s)
	{
		SetName(988);
		SetSkin(10);
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

		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(7);
		PlayAnimationOffset(8);

		SetUseText(988);

		SetAttachedWeapon( 224 );
	} ]

	OnUse[ (s)
	{
		OpenMenu("trinketconvo");
	} ]

	SummonMe[()
	{
		SetPosition(26496, 10624, -3840);
	}]
}
