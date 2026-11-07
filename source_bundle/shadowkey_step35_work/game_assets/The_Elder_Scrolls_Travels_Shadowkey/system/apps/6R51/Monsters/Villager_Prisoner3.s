{
	Init[ (s)
	{
		if(GetPlayer().saved_Rescue3 = 0)
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
		if(GetPlayer().saved_Rescue3 = 0)
		{
			OpenMenu("delfhide\\\\RescueConvo");
			GetPlayer().saved_Rescue3 = 1;
		}
		else
		{
			OpenMenu("Thanks");
		}
	} ]

	SummonMe[()
	{
		SetPosition(27981, 11443, -3840);
	}]
}