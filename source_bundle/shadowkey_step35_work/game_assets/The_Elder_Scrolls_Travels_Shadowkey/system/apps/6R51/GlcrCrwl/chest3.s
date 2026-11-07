{
	Init[()
	{
		SetName(640);
		SetUseText(640);
		SetUsable(true);

		Item = Level.CreateEntity(4726);
		AddObject(Item);

		Item = Level.CreateEntity(4726);
		AddObject(Item);

		Item = Level.CreateEntity(4501);
		AddObject(Item);
	}]

	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}