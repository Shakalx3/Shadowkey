{
	DestroyMe [0]

	Init[ (s)
	{
		SetName(456);
		SetUseText(1923);
		SetUsable( true );
	}]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	}]
}