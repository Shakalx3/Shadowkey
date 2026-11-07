{
	Init[ (s)
	{
		SetName(1638);
		SetShortName(1639);
		SetUsable( true );
		SetUseText(1640);
		SetCost( 1340 );
		SetMarketValue( 469 );
		SetItemDescription(1641);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Permanent, Speed, Increment, 5);
		GetOwner().AddEffect(Permanent, Personality, Increment, -2);
		GetOwner().AddEffect(Permanent, Strength, Increment, -1);
		DestroyObject(self);
	} ]
}