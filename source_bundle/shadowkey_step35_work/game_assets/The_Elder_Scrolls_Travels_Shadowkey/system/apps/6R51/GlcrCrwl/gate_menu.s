{
	Init[()
	{
		if(GetPlayer().HasItem("skey11") = false)
		{
			AddStaticItem(1553);
		}
		else
		{
			AddStaticItem(1554);
		}
		AddMenuItem(386, "Quit");
	}]
}