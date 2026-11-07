{
	Init[ (s)
	{
		if(GetPlayer().saved_Rescue4 = 0)
		{
			SetUseText(2147);
		}
		else
		{
			SetUseText(3766);
		}
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
		if(GetPlayer().saved_Rescue4 = 0)
		{
			OpenMenu("delfhide\\\\RescueConvo");
			GetPlayer().saved_Rescue4 = 1;
		}
		else
		{
			OpenMenu("Thanks");
		}
	} ]

	SummonMe[()
	{
		SetPosition(24824, 2571, -2816);
	}]
}