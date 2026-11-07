{
	Init[ (s)
	{
		SetName(1173);
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
		SetUseText(1173);
		SetUsable(true);
		SetInvulnerable( true );
	} ]

	OnUse[ (s)
	{
		OpenMenu("dstar_w\\\\Porliss_Convo2");
	}]
}
