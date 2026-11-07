{
	Init[ (s)
	{
		AddStaticItem(1322);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(1323);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(1324);
		AddStaticItem(179, false);
		AddMenuItem(1325, "Quit");
	} ]
}