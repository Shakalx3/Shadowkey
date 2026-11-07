{
	Init[ (s)
	{
		SetName(552);
		SetAggressive(false);
		SetID("azra");
		SetUseText(553);
		SetUsable(true);
		SetInvulnerable(true);
		SetIdleAnimation(0);
	} ]

	OnUse[()
	{
		GetPlayer().OpenMenu("ffarena\\\\azra_convo1");
	}]

	SummonMe[()
	{
		SetPositionMirror(12390, 8064, 0);
	}]
}
