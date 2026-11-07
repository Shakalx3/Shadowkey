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
		Level.Log("On use calling raiders loot7");
		OpenMenu("Raiders\\\\Loot7");
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