{
	Init[ (s)
	{
		SetName(2047);
		SetSkin(1);
		SetExpWorth(0);
		SetAggressive(false);
		SetWalkAnimation(5);
		SetSwingAnimation(3);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);
		SetUsable(true);
		SetInvulnerable(true);
		SetUseText(3284);
	} ]

	OnUse[()
	{
		GetPlayer().OpenMenu("dstar_w\\\\colleen_convo");
	}]
}
