{
	Init[ (s)
	{
		SetName(1624);
		SetShortName(1625);
		SetUsable( true );
		SetUseText(1626);
		SetCost( 1100 );
		SetMarketValue( 385 );
		SetItemDescription(1627);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Permanent, Agility, Increment, 5);
		GetOwner().AddEffect(Permanent, Endurance, Increment, -2);
		GetOwner().AddEffect(Permanent, Strength, Increment, -1);
		DestroyObject(self);
	} ]
}