{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(2260);
		AddStaticItem(179, false);
		AddMenuItem(2264, "More");
	}]

	More[()
	{
		if(Level.saved_Trinket = 1)
		{
			ClearMenu();
			AddStaticItem(3750);
			AddStaticItem(179, false);
			AddMenuItem(386, "Quit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3749);
			AddStaticItem(179, false);
			AddMenuItem(386, "Quit");
		}
	}]
}