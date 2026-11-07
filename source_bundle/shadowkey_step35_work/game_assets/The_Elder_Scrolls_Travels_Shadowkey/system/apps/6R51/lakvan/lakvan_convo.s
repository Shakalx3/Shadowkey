{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1825);
		AddStaticItem(1826);
		AddStaticItem(1827);
		AddStaticItem(179, false);
		AddMenuItem(182, "TasteThis1");
	}]

	TasteThis1[()
	{
		ClearMenu();
		AddStaticItem(1828);
		AddStaticItem(179, false);
		AddMenuItem(1829, "MenuQuit");
	}]

	MenuQuit[()
	{
		if(Level.saved_LakvanAgro = 0)
		{
			Level.GetEntity("lakvan").SetAggressive(true);
			Level.GetEntity("lakvan").SetUsable(false);
			//Level.GetEntity("lakvan").AiDetect();
			Level.saved_LakvanAgro = 1;
		}
		Quit();
	}]
}