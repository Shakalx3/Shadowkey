{
	Init[ (s)
	{
		AddStaticItem("Use your Shadow key on door?");
		AddStaticItem(179, false);
		AddMenuItem(386,"TurnKey");
		AddMenuItem("Not right now.","MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]

	TurnKey[ (s)
	{
		Door = Level.GetEntity("sdoor");
		Door.DestroyObject(Door);
		Level.saved_SSdoor = 1;
		Quit();
	}]
}