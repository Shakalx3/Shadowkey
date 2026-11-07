{
	Init[ (s)
	{
		SetName(2095);
		SetExpWorth(200);
		SetLevel(4);
		SetSkin(0);
		SetAggressive(false);
		SetAttack(4);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(6);
		SetDamageMin(3);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(18000);

		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		PlayAnimation(0);
		SetUseText(2095);
		SetUsable(true);
		SetModel(61);
		SetInvulnerable( true );

		SetMob(1);
	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("twilite\\\\Ivgrizt_Convo");
	}]
}
