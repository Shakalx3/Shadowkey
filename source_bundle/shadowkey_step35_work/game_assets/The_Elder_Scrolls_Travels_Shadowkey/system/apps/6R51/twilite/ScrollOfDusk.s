{
	Loot2 [0]
	Init[ (s)
	{
		SetUseText(2583);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{

		if( Loot2 = 0)
		{
		OpenMenu("twilite\\\\Loot2");
		}
		else
		{
		OpenMenu("NoLoot");
		}

	} ]

	MenuQuit[()
	{
		Quit();
	}]
}