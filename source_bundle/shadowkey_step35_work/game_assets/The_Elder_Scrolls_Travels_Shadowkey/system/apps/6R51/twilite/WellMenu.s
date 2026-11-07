{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2751);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(2752);
		AddStaticItem(179, false);
		AddMenuItem(2754, "Drink");
		AddMenuItem(2753, "MenuQuit");
	}]

	Drink[()
	{
		Charges = GetOpener().saved_Charges;
		Level.Log("Charges is currently " # Charges);
		if( Charges > 0 )
		{
			GetPlayer().SetMagicka( GetPlayer().GetMagicka() + 5 );
			GetPlayer().SetFatigue( GetPlayer().GetFatigue() + 50 );
			GetOpener().saved_Charges = GetOpener().saved_Charges - 1;
			Quit();
		}
		else
		{
			OpenMenu("twilite\\\\NothingLeft");
			Level.GetEntity("well").SetUsable(false);
		}

	}]

	MenuQuit[()
	{
		Quit();
	}]
}