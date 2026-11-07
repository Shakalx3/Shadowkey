{
	Init[()
	{
		AddStaticItem(3029);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(3030);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(3031);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(3032);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
	}]
}