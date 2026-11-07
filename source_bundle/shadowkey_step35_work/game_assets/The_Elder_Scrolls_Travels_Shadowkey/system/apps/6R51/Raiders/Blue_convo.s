{
	Init[ ()
	{
		AddStaticItem(3705);
		AddStaticItem(179, false);
		AddMenuItem(3590, "DoorOpen");
		AddMenuItem(3697, "MenuQuit");

	}]

	DoorOpen[ ()
	{
		ClearMenu();
		AddStaticItem(3706);
		AddStaticItem(179, false);
		AddMenuItem(3590, "MenuQuit");
		Door = Level.GetEntity("bldoor");
		Door.DestroyObjectMirror(Door);
		Level.saved_Blue=1;
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}