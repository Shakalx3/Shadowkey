{
	Init[ (s)
	{
		SetName(3143);
		SetExpWorth(0);
		SetLevel(6);

		SetAggressive(false);
		SetWalkAnimation(5);
		SetSwingAnimation(3);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);
		SetUsable(true);
		SetInvulnerable(true);
		SetUseText(3225);
	} ]

	OnUse[()
		{
			GetPlayer().OpenMenu("dstar_w\\\\bread_menu3");
		}]

}
