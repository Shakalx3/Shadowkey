{
	Loot1 [0]
	Init[ (s)
	{
		SetUseText(2583);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{

		if( Loot1 = 0)
		{
		OpenMenu("twilite\\\\Loot1");
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