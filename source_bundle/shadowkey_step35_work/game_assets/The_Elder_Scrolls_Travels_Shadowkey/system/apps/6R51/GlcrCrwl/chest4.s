{
	Init[()
	{
		SetUseText(615);
		SetUsable(true);
		Item = Level.CreateEntity(52);
		Item.SetQuantity(Random(300, 430));
		AddObject(Item);
	}]
	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}