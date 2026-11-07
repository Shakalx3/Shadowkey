{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3694);
		AddStaticItem(179, false);
		AddMenuItem(1389, "MenuQuit");
		AddMenuItem(591, "OpenGate");
	}]

	OpenGate[ ()
	{
		ClearMenu();
		gateA = Level.GetEntity("keydoor");
		gateA.DestroyObjectMirror(gateA);
		//  Key8 = GetPlayer().FindInventory("skey8");
		//  GetPlayer().RemoveItem(Key8);
		GetPlayer().PlaySound( 63 );
		Level.saved_Gate2Zone= 1;
		Quit();
	}]
	MenuQuit[()
	{
		Quit();
	}]
}
