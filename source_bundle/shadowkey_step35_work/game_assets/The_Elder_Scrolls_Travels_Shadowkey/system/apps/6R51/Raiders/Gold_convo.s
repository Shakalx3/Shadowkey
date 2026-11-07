{
	Init[ ()
	{
		AddStaticItem(3707);
		AddStaticItem(179, false);
		AddMenuItem(3590, "DoorOpen");
		AddMenuItem(3697, "MenuQuit");

	}]

	DoorOpen[ ()
	{
		ClearMenu();
		AddStaticItem(3708);
		AddStaticItem(179, false);
		AddMenuItem(3590, "MenuQuit");
		Door = Level.GetEntity("gddoor");
		Door.DestroyObjectMirror(Door);
		Level.saved_Gold=1;
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}