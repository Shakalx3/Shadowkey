
{
	Init[ ()
	{

		if (Level.saved_ETalk01 = 0)

		{
			ClearMenu();
			AddStaticItem(1209);
			AddStaticItem(1210);
			AddStaticItem(179, false);
			AddMenuItem(1211, "MenuQuit");
			AddMenuItem(1212, "Talk1");
		}
		else
		{
			ClearMenu();
			AddStaticItem(1213);
			AddStaticItem(179, false);
			AddMenuItem(1132, "MenuQuit");

		}
	}]

	Talk1[ ()
	{
		ClearMenu();
		AddStaticItem(1214);
		AddStaticItem(179, false);
		AddMenuItem(182, "Talk2");
	}]

	Talk2[ ()
	{
		ClearMenu();
		AddStaticItem(1215);
		AddStaticItem(179, false);
		AddMenuItem(182, "Talk3");
	}]

	Talk3[ ()
	{
		ClearMenu();
		AddStaticItem(1216);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
		GetPlayer().AddExperience(300);
		Level.saved_ETalk01 = 1;
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}