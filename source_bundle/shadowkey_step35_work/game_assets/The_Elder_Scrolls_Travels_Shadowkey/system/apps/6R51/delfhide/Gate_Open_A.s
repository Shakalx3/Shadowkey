{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3099);
		AddStaticItem(179, false);
		AddMenuItem(591, "OpenGate");
		AddMenuItem(1389, "MenuQuit");
	}]

	OpenGate[ ()
	{
		ClearMenu();
		gateA = Level.GetEntity("GTA");
		gateA.DestroyObjectMirror(gateA);
		GetPlayer().PlaySound( 63 );
		Level.saved_GateA = 1;
		Quit();
	}]
	MenuQuit[()
	{
		Quit();
	}]
}
