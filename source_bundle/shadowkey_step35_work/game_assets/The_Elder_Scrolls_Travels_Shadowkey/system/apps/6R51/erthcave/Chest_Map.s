{
	Init[ (s)
	{
		SetUseText(368);
		SetUsable(true);
		SetName(368);
		Item = Level.CreateEntity( 928 );
		AddObject( Item );
	}]

	OnUse[ (s)
	{
		OpenMenu("erthcave\\\\Loot_map");

	}]

	LootChest[ (s)
	{
		GetPlayer().SetQuestSolved(7);
		OpenMenu("LootMenu");
	}]

}