{
	Init[ (s)
	{
		SetName(3117);
		SetExpWorth(0);
		SetLevel(6);

		SetWalkAnimation(5);
		SetSwingAnimation(3);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);
		SetUsable(true);
		SetInvulnerable(true);
		SetUseText(3116);
	} ]

	OnUse[()
		{
			GetPlayer().OpenMenu("dstar_w\\\\Fine");
		}]

}
