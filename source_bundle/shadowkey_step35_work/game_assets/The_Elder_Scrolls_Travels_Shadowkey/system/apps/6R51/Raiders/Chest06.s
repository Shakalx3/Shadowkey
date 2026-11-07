{
	Loot6 [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( Loot6 = 0)
		{
		OpenMenu("raiders\\\\Loot6");
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