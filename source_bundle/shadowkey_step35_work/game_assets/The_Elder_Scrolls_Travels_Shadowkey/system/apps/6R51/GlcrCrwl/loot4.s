{
	Init[()
	{
		AddStaticItem(1560);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "Quit");
	}]
	Take[()
	{
		Quit();
	}]
}