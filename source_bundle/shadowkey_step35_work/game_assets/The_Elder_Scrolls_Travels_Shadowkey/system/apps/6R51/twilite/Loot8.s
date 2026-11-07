{
	Init[(s)
	{
		ClearMenu();
		AddStaticItem(2691);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	Take[(s)
	{
		ClearMenu();
		GetPlayer().SetQuestSolved(19);
		GetOpener().GetLoot();
	}]

	MenuQuit[(s)
	{
		Quit();
	}]

	Loot81Back[()
	{
		// handle the right softkey
		MenuQuit();
	}]
}