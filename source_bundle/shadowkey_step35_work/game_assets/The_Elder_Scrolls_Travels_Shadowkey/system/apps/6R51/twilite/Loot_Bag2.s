{
	Init[ (s)
	{
		SetUseText(2670);
		SetUsable(true);
		SetName(864);
		SetID("Bag");

		Item=Level.CreateEntity(52);
		Item.SetQuantity(Random(10,28));
		AddObject( Item );
		SetDestroy(true);
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}