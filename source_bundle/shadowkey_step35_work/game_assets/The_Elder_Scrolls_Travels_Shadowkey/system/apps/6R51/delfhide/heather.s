{
	Init[ (s)
	{
		SetUseText(835);
		SetName(835);
		SetID("heather");
		SetSkin(0);
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(7);
		PlayAnimationOffset(7);
		SetInvulnerable(true);
		SetAggressive(false);

	} ]

	OnUse[ (s)
	{
		if(GetPlayer().saved_Heather = 0)
		{
			OpenMenu("delfhide\\\\Heather_Locket_Convo");
		}
		else
		{
			OpenMenu("Heather_Locket_Convo");
		}
	} ]

	SummonMe[()
	{
		SetPosition(29943, 8079, -2816);
	}]
}