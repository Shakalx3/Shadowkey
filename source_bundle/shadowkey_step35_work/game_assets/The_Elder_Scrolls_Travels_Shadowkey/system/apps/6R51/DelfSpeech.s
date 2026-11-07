{
	Init[ (s)
	{
		AddStaticItem( 936 );
		AddStaticItem(179, false);
		AddMenuItem( 937, "Talker" );
		AddMenuItem( 938, "MenuQuit" );
	} ]

	Talker[ (s)
	{
		ClearMenu();
		AddStaticItem( 939 );
		AddStaticItem(179, false);
		AddMenuItem( 528, "MenuQuit" );
	} ]

	MenuQuit[ (s)
	{
		Quit();
		Level.GetEntity("delfran").SetAggressive(true);
		Level.GetEntity("delfran").SetUsable(false);
		Level.GetEntity("delfran").AiDetect();
		Level.saved_DelfSpeech = 1;

	} ]
}