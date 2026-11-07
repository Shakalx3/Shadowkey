{

	Init[ (s)
	{
		Speak = Random(1,8);

		switch(Speak)
		{
			case 1
			{
				AddStaticItem(3422);
				AddStaticItem(179, false);
				AddMenuItem(3147, "MenuQuit");
				return;
			}
			case 2
			{

				AddStaticItem(3423);
				AddStaticItem(179, false);
				AddMenuItem(3424, "MenuQuit");
				return;
			}
			case 3
			{

				AddStaticItem(3425);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				return;
			}
			case 4
			{

				AddStaticItem(3426);
				AddStaticItem(179, false);
				AddMenuItem(3152, "MenuQuit");
				return;
			}
			case 5
			{

				AddStaticItem(3153);
				AddStaticItem(179, false);
				AddMenuItem(3154, "MenuQuit");
				return;
			}
			case 6
			{
				AddStaticItem(3427);
				AddStaticItem(179, false);
				AddMenuItem(884, "MenuQuit");
				return;
			}
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]
}







