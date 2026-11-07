{
	Init[ (s)
	{
		AddStaticItem(809);
		AddStaticItem(179, false);
		AddMenuItem(182,"More");
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(810);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(811);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		Level.saved_Menu8 = 1;
	} ]
}