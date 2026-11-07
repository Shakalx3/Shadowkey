{
	Init[ (s)
	{
		AddStaticItem(793);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
		Level.saved_DoneRoom15 = 1;

	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(794);
		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
	} ]
}