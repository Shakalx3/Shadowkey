{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3100);
		AddStaticItem(179, false);
		AddMenuItem(591, "Open");
		AddMenuItem(1389, "MenuQuit");
	}]

	Open[ ()
	{
		ClearMenu();
		gateB = Level.GetEntity("GTB");
		gateB.DestroyObjectMirror(gateB);
		GetPlayer().PlaySound( 63 );
		Level.saved_GateB = 1;
		Quit();
	}]
	MenuQuit[()
	{
		Quit();
	}]
}
