{
	Init[(s)
	{
		SetName(368);
		SetUseText(1367);
		SetUsable(true);

		Item = Level.CreateEntity( 807 );
		AddObject( Item );
	}]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
		GetPlayer().SetQuestSolved(21);
	}]
}