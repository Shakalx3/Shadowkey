{
	MetPlayerBefore [0]

	Init[ (s)
	{
		SetName(1332);
		SetUseText(1333);
		SetUsable(true);
		SetInvulnerable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().OpenMenu("erthcave\\\\EC_Menu3");
	} ]
}