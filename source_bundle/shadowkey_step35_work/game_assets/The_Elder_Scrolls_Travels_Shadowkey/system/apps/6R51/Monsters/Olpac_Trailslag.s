{
	saved_Killed [0]
	done_menu [0]

	Init[ (s)
	{
		SetInvulnerable( true );
		SetName(2108);
		SetUseText(2108);
		SetExpWorth(0);
		SetLevel(0);
		SetSkin(3);
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
		SetChaseRadius(25000);

		SetWalkAnimation(0);
		SetSwingAnimation(0);
		SetDeathAnimation(0);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		AiDetect();
	} ]

	OnDetect[()
	{
		if( (done_menu = 0) and (not GetPlayer().QuestSolved(14) ) )
		{
			GetPlayer().OpenMenu("ghstpass\\\\GP_Menu3");
			done_menu = 1;
			SetMPDone();
			// call SetMPDone() on all the clients
			MirrorMethod( "SetMPDone" );
		}
		AiSleep();
	}]

	OnUse[ (s)
	{
		OpenMenu("ghstpass\\\\Trailslag_convo");
	} ]

	SetMPDone[ (s)
	{
		done_menu = 1;
	} ]
}
