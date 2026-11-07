{
	Init[()
	{
		if(Level.saved_WeTalked = 0)
		{
			ClearMenu();
			AddStaticItem(557);
			AddStaticItem(558);
			AddStaticItem(179, false);
			AddMenuItem(559, "Help");
			AddMenuItem(386, "Quit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(563);
			AddStaticItem(179, false);
			AddMenuItem(386, "Quit");
		}
	}]

	Help[()
	{
		ClearMenu();
		AddStaticItem(561);
		AddStaticItem(562);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreHelp");
	}]

	MoreHelp[()
	{
		ClearMenu();
		AddStaticItem(563);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		Level.saved_WeTalked = 1;
	}]
}