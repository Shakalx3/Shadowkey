{
	Loot7 [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( Loot7 = 0)
		{
		OpenMenu("lakvan\\\\Loot7");
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