{
	Init[()
	{
		SetUseText(615);
		SetUsable(true);
		Item = Level.CreateEntity(52);
		Item.SetQuantity(Random(200, 450));
		AddObject(Item);
	}]
	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}