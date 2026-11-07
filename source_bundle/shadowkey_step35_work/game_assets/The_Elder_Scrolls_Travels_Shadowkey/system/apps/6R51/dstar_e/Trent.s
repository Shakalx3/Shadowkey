{
	Init[ (s)
	{
		SetName(3216);
		SetExpWorth(0);
		SetLevel(6);
		SetAggressive(false);
		SetWalkAnimation(5);
		SetSwingAnimation(3);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		SetAttack(1);
		SetDefense(1);
		SetSpellcast(0);
		SetMagicResistance(1);
		SetDamageMin(4);
		SetDamageMax(24);
		SetArmorValue(1);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(10000);

		PlayAnimationOffset(7);
		SetUsable(true);
		SetInvulnerable(true);
		SetUseText(3216);
	} ]

	OnUse[()
		{
			GetPlayer().OpenMenu("dstar_e\\\\Money04_convo");
		}]

}
