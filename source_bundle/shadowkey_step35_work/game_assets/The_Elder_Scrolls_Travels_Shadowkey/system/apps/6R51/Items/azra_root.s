{
	Init[ (s)
	{
		SetName(1595);
		SetShortName(1596);
		SetUsable( true );
		SetUseText(1597);
		SetCost( 3200 );
		SetMarketValue( 1120 );
		SetItemDescription(1598);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Permanent, Intelligence, Increment, 5);
		GetOwner().AddEffect(Permanent, Endurance, Increment, -2);
		GetOwner().AddEffect(Permanent, Strength, Increment, -1);
		//DestroyObject(self);
	} ]
}