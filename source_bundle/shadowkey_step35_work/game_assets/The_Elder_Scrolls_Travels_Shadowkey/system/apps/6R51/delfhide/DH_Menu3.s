{
	Init[ (s)
	{
		AddStaticItem(790);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");

	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(791);
		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
	} ]
}