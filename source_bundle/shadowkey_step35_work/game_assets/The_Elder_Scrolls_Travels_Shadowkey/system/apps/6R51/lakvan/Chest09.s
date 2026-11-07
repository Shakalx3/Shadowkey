{
	Loot9 [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( Loot9 = 0)
		{
		OpenMenu("lakvan\\\\Loot9");
		}
		else
		{
		OpenMenu("NoLoot");
		}

	} ]
	
	RemoveContents[ ()
	{
		Loot9 = 1; //don't allow host access to contents again
		GetOpener().SetUsable(false);
	}]

	MenuQuit[()
	{
		Quit();
	}]
}