{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2216);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(1053);
		AddStaticItem(1054);
		AddStaticItem(179, false);
		AddMenuItem(2217, "MagickaAxe");
		AddMenuItem(2218, "CastReduction");
	}]

	MagickaAxe[()
	{
		ClearMenu();
		AddStaticItem(2219);
		AddStaticItem(2220);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreMagickaAxe");
	}]

	MoreMagickaAxe[()
	{
		ClearMenu();
		AddStaticItem(2221);
		AddStaticItem(179, false);
		AddMenuItem(386, "TakeAxe");
	}]

	CastReduction[()
	{
		ClearMenu();
		AddStaticItem(2219);
		AddStaticItem(2222);
		AddStaticItem(179, false);
		AddMenuItem(386, "TakeMana");

	}]

	TakeAxe[()
	{
		GetOpener().GetAxe();
	}]

	TakeMana[()
	{
		GetOpener().GetMana();
	}]

	MenuQuit[();
	{
		Quit();
	}]

	ShadowLootBack[()
	{
		// handle the right softkey
		MenuQuit();
	}]
}