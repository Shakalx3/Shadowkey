{
	Init[()
	{
		SetUseText(615);
		SetUsable(true);

		Item = Level.CreateEntity(52);
		Item.SetQuantity(Random(124, 224));
		AddObject(Item);
	}]
	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}