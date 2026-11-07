{

	Init[ (s)
	{
		AddStaticItem(2976);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]
	More1[()
	{
		ClearMenu();
		AddStaticItem(2977);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(2978);
		AddStaticItem(179, false);
		AddMenuItem(517, "Quit");
	}]

}