{
	Init[()
	{
		SetUseText(368);
		SetUsable(true);
		Item = Level.CreateEntity(535);
		AddObject( Item );

		Item = Level.CreateEntity(906);
		AddObject( Item );
	}]

	OnUse[()
	{
		//OpenMenu("fearfrst\\\\loot4_menu");
		OpenMenu("LootMenu");
	}]

	//OpenBag[ ()
	//{
	//	OpenMenu("LootMenu");
	//}]
}
