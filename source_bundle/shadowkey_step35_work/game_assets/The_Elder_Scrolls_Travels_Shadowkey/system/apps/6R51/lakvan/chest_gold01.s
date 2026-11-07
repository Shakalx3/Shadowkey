{
	Init[ (s)
	{
		SetUseText(368);
		SetUsable(true);
		SetName(611);
		SetID("Chest");

		Item = Level.CreateEntity(52);
		Item.SetQuantity(Random(1500,2500));
		AddObject(Item);
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}