{
	Init[ (s)
	{
		SetName(552);
		SetAggressive(false);
		SetUseText(552);
		SetUsable(true);
		SetInvulnerable(true);
		SetIdleAnimation(0);
	} ]

	OnUse[()
	{
		GetPlayer().OpenMenu("azra_convo2");
	}]

	SummonMe[()
	{
		SetPosition(21469, 12318, -8082);
	}]

	SummonMe2[()
	{
		SetPosition(24970, 4173, -2816);
	}]
}
