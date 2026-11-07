{
	Init[ (s)
	{
		AddStaticItem(3926);
		AddStaticItem(179, false);
		AddMenuItem(386,"TurnKey");
		AddMenuItem(1935,"MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]

	TurnKey[ (s)
	{
		Door = Level.GetEntity("sdwdooB");
		Door.DestroyObjectMirror(Door);
		Level.saved_SSdoor = 1;
		Quit();
	}]
}