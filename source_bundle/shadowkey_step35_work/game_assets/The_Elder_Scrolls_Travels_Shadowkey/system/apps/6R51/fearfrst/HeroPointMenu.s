{
	Init[()
	{
		AddStaticItem(1340);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreResponse");
	}]
	MoreResponse[()
	{
		ClearMenu();
		AddStaticItem(1341);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
	}]
}