{
	Init[ (s)
	{
		SetName(2048);
		SetIdleAnimation(1);
		PlayAnimationOffset(0);
		SetUseText(2048);
		SetUsable(true);
		SetInvulnerable(true);
		SetSkin(5);
	} ]

	OnUse[()
	{
		GetPlayer().OpenMenu("crypt1\\\\caretaker_convo");
	}]
}
