{
	Init[()
	{
		if (Level.saved_teethplaced = 0)
		{
			AddStaticItem(679);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");

		}
		if (Level.saved_teethplaced = 1)
		{
			AddStaticItem(680);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");

		}
		if (Level.saved_teethplaced = 2)
		{
			AddStaticItem(681);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");

		}
		if (Level.saved_teethplaced = 3)
		{
			AddStaticItem(682);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");

		}
		if (Level.saved_teethplaced = 4)
		{
			AddStaticItem(683);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");

		}
		if (Level.saved_teethplaced = 5)
		{
			AddStaticItem(684);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");

		}
		if (Level.saved_teethplaced = 6)
		{
			AddStaticItem(685);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
		}
		Level.saved_teethplaced = Level.saved_teethplaced +1;

	}]

	MenuQuit[()
	{
		Quit();
	}]
}