{
	Init[()
	{
		MenuBackground(69);
		Retry();
	}]

	Retry[()
	{
		ClearMenu();
		AddStaticItem(3300);
		AddMenuItem(718, "Try");
		AddMenuItem(517, "Quit");
	}]

	Try[()
	{
		AutoSave();
	}]

	SaveGameCallBack[(s)
	{
		ClearMenu();
		if(s = 1)
		{
			AddStaticItem(1967);
			AddMenuItem(517, "Quit");
		}
		else
		{
			AddStaticItem(1968);
			AddMenuItem(387, "Retry");
		}
	}]
}
