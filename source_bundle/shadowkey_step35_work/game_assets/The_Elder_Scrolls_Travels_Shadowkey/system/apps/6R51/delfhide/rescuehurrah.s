{
	Init[ (s)
	{

		ClearMenu();
		AddStaticItem(904);
		AddStaticItem(179, false);
		AddMenuItem(528, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Birgitta = Level.GetEntity("birg");
		Birgitta.DestroyObjectMirror(Birgitta);
		Level.saved_Birg = 1;
		Quit();
	}]
}