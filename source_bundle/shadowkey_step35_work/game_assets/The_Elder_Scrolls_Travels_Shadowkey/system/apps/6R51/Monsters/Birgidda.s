{
	Init[ (s)
	{
		SetName(2035);
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

		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(0);
		SetSkin(3);
		SetID("birg");
		SetUseText(2036);
		SetUsable(true);
		SetInvulnerable(true);

	} ]


	OnUse[ (s)
	{
		GetPlayer().SetQuestSolved(2,true);
		GetPlayer().OpenMenu("delfhide\\\\rescuehurrah");
		Level.saved_Birgitta = 1;
		GetPlayer().saved_Birgidda = 1;
	} ]
}
