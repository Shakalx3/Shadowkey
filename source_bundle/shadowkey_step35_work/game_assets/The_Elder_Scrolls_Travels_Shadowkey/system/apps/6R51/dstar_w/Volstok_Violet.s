{
	Init[ (s)
	{
		SetName(1235);
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
		SetUseText(1235);
		if(GetPlayer().QuestCompleted(20) = true)
		{
			SetUsable(true);
		}
		else
		{
			SetUsable(false);
		}
		SetInvulnerable( true );
	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("dstar_w\\\\volstok_convo");
	}]
}
