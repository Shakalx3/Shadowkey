{
	Init[()
	{
		AddStaticItem(2963);
		AddStaticItem(2964);
		AddStaticItem(179, false);
		AddMenuItem(386, "Vibrate");
	}]

	Vibrate[()
	{
		ClearMenu();
		AddStaticItem(2965);
		AddStaticItem(179, false);
		AddMenuItem(434, "Open");
		AddMenuItem(1389, "Quit");
	}]

	Open[()
	{
		ClearMenu();
		AddStaticItem(2966);
		AddStaticItem(2967);
		AddStaticItem(2968);
		AddStaticItem(179, false);
		AddMenuItem(386, "Broken");
	}]

	Broken[()
	{
		Level.saved_Ice2 = 1;
		Door = Level.GetEntity("s_ice2");
		Door.DestroyObjectMirror(Door);
		Quit();
	}]
}