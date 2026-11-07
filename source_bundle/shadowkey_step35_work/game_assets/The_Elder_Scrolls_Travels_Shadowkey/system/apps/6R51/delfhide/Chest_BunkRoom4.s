
{
	Init[ (s)
	{
		// 12-24 gold, two loaves

		SetName(611);
		SetUseText(368);
		SetUsable( true );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( Random(12,24) );
		AddObject( Item );

		Item = Level.CreateEntity( 700 );
		AddObject( Item );

		Item = Level.CreateEntity( 700 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}