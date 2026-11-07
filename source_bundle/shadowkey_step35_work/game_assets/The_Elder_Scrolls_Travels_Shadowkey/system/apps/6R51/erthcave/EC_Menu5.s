{
	Init[ (s)
	{
		AddStaticItem(1308);
		AddStaticItem(179, false);
		AddMenuItem(1309, "UnsealCase");
		AddMenuItem(528, "Quit");
	} ]

	UnsealCase[ (s)
	{
		ClearMenu();
		AddStaticItem(1310);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	} ]

	More1[ (s)
	{
		ClearMenu();
		AddStaticItem(1311);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(1312);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	} ]

	More3[ (s)
	{
		ClearMenu();
		AddStaticItem(1313);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	} ]

	More4[ (s)
	{
		ClearMenu();
		AddStaticItem(1314);
		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
		GetPlayer().SetQuestSolved(6);
	} ]
}