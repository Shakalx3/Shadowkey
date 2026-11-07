{
	saved_TakeScrolls[0]
	saved_TakeCleaver[0]
	saved_Chest04 [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( saved_Chest04 < 3)
		{
			OpenMenu("twilite\\\\Loot4");
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