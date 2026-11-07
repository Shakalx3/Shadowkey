{

	Init[ (s)
	{
		Speak = Random(1,8);

		switch(Speak)
		{
			case 1
			{
				AddStaticItem(3183);
				AddStaticItem(179, false);
				AddMenuItem(758, "MenuQuit");
				return;
			}
			case 2
			{

				AddStaticItem(3184);
				AddStaticItem(179, false);
				AddMenuItem(3149, "MenuQuit");
				return;
			}
			case 3
			{

				AddStaticItem(3185);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				return;
			}
			case 4
			{

				AddStaticItem(3186);
				AddStaticItem(179, false);
				AddMenuItem(3152, "MenuQuit");
				return;
			}
			case 5
			{

				AddStaticItem(3187);
				AddStaticItem(179, false);
				AddMenuItem(3188, "MenuQuit");
				return;
			}
			case 6
			{
				AddStaticItem(3189);
				AddStaticItem(179, false);
				AddMenuItem(3190, "MenuQuit");
				AddMenuItem(3191, "BlackMenu");
				return;
			}
		}
	}]



	BlackMenu[()
	{
				ClearMenu();
				AddStaticItem(3192);
				AddStaticItem(3193);
				AddStaticItem(179, false);
				AddMenuItem(182, "More");

	}]

	More[()
	{
				ClearMenu();
				AddStaticItem(3194);
				AddStaticItem(3193);
				AddStaticItem(179, false);
				AddMenuItem(1082, "MenuQuit");

	}]

	MenuQuit[()
	{
		Quit();
	}]
}







