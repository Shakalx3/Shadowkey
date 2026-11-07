{
	Init[()
	{
		if (Level.saved_Shadowgate = 0)
		{
			AddStaticItem(677);
			AddStaticItem(179, false);
			AddMenuItem(651, "MenuQuit");
			Racial = GetPlayer().GetRaceAbility() + 3;
			GetPlayer().SetRaceAbility(Racial);
			GetPlayer().PlaySound(87);
		}
	}]

	MenuQuit[()
	{
		Level.saved_Shadowgate = Level.saved_Shadowgate +1;
		Quit();
	}]
}