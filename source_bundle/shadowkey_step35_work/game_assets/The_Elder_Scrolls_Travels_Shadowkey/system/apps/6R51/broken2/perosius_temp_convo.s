{

	Init[()
	{
		if (GetPlayer().QuestCompleted(46) = true)
		{
			ClearMenu();
			AddStaticItem(509);
			AddStaticItem(179, false);
			AddMenuItem(182,"More10");
		}

		else
		{
			ClearMenu();
			AddStaticItem(510);
			AddStaticItem(179, false);
			AddMenuItem(511,"MenuQuit");
		}
	}]

	More10[()
	{
		ClearMenu();
		AddStaticItem(512);
		AddStaticItem(179, false);
		AddMenuItem(513,"More11");
	}]

	More11[()
	{
		ClearMenu();
		AddStaticItem(514);
		AddStaticItem(179, false);
		AddMenuItem(511,"MenuQuit");
	}]

	MenuQuit[()
	{
		//Pero = Level.GetEntity("pero");
		//Pero.SetAggressive(true);
		//Pero.SetUsable(false);
		//Pero.SetInvulnerable(false);
		Quit();
	}]

}