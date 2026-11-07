{
	Init[ (s)
	{
		SetUseText(1199);
		SetExpWorth(0);
		SetLevel(0);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);
		SetInvulnerable( true );
	} ]

	OnUse[ (s)
	{
		OpenMenu("dstar_w\\\\Rmoney_menu0");
	} ]
}