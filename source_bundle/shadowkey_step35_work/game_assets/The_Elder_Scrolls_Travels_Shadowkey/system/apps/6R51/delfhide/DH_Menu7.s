{
	Init[ (s)
	{
		AddStaticItem(802);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(803);
		AddStaticItem(179, false);
		AddMenuItem(805, "OffHeGoes");
		AddMenuItem(804, "AttackQuit");
	} ]

	AttackQuit[ (s)
	{
		Level.GetEntity("guard").SetAggressive = true;
		Level.GetEntity("guard").SetUsable = false;
		Quit();
	} ]

	OffHeGoes[ (s)
	{
		ClearMenu();
		AddStaticItem(806);
		AddStaticItem(807);
		AddStaticItem(179, false);
		AddMenuItem(808, "Quit");
		GetOpener().DestroyObjectMirror( GetOpener() );
	} ]
}