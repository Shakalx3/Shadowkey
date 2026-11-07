{
	Desk[0]

	Init[()
	{

		if (Level.BledDesk = 1)
		{
			SetUsable(false);
		}

		else
		{
			SetUsable(true);
			SetUseText(442);
			SetMPUsable(true);
		}
	}]

	OnUse[(s)
	{
		if(Desk = 0)
		{
			OpenMenu("broken1\\\\loot1_menu");
		}
		else
		{
			OpenMenu("broken1\\\\loot_empty");
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]
}