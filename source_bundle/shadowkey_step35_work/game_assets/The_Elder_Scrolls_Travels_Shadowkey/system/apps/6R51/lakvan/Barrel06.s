{
	Loot6 [0]
	Init[ (s)
	{
		SetUseText(861);
	} ]

	OnUse[ (s)
	{

		if( Loot6 = 0)
		{
		OpenMenu("lakvan\\\\Loot6");
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