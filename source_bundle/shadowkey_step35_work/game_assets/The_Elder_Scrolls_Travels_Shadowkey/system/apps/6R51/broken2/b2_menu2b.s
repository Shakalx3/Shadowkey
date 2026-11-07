{
	Init[()
	{
		skey10 = GetPlayer().FindInventory("skey10");
		if(skey10 = null)
		{
			ClearMenu();
			AddStaticItem(501 );
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
		}

		else
		{
			ClearMenu();
			AddStaticItem(502);
			AddStaticItem(179, false);
			AddMenuItem(386,"MenuQuit");
			Level.ShadowKey10b = 1;
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]
}