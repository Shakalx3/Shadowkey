{

	Init[ (s)
	{


		ClearMenu();
		AddStaticItem(914 );
		AddStaticItem(915 );
		AddStaticItem(916 );
		AddStaticItem(917);
		AddStaticItem(179, false);
		AddMenuItem( 419, "MoreResponse" );
	} ]


	MoreResponse [ (s)
	{

		ClearMenu();
		AddStaticItem(918);
		AddStaticItem(919);
		AddStaticItem(920);
		AddStaticItem(921);
		AddStaticItem(179, false);
		AddMenuItem(182, "Trinket2");

	} ]

	Trinket2[ (s)
	{
		ClearMenu();
		AddStaticItem(922);
		AddStaticItem(923);
		AddStaticItem(924);
		AddStaticItem(925);
		AddStaticItem(179, false);
		AddMenuItem(182, "Azraspeak");
	} ]

	Azraspeak[ (s)
	{
		ClearMenu();
		AddStaticItem(926);
		AddStaticItem(927);
		AddStaticItem(928);
		AddStaticItem(929);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	} ]

	MenuQuit[ (s)
	{
		Skelos = Level.GetEntity("skelos");
		Skelos.DestroyObjectMirror(Skelos);
		Quit();
	} ]
}