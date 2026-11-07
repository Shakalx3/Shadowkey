{
	Init[ (s)
	{
		AddStaticItem(3709);
		AddStaticItem(179, false);
		AddMenuItem(3590, "DoorOpen");
		AddMenuItem(3697, "MenuQuit");

	}]

	DoorOpen[ (s)
	{
		ClearMenu();
		AddStaticItem(3710);
		AddStaticItem(179, false);
		AddMenuItem(3590, "MenuQuit");
		Door = Level.GetEntity("rddoor");
		Door.DestroyObjectMirror(Door);
		Level.saved_Red=1;

	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}