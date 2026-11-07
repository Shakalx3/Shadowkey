{
	Init[ (s)
	{
		SetUseText(2147);
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
		OpenMenu("delfhide\\\\RescueConvo");
	} ]
}