{
	Init[ (s)
	{
		SetName(1062);
		SetSkin(6);

		SetAggressive(false);

		SetUsable(true);
		SetUseText(1062);

		SetInvulnerable(true);
	} ]

	OnUse[ (s)
	{
		OpenMenu("AzraTanyinConvo");
	} ]
}
