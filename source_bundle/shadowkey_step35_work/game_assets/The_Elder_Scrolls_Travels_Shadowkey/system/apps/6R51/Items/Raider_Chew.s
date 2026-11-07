{
	Init[ (s)
	{
		SetName(3689);
		SetShortName(3690);
		SetUsable( true );
		SetUseText(3691);
		SetCost( 2470 );
		SetMarketValue( 865 );
		SetItemDescription(3692);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Permanent, Strength, Increment, 5);
		GetOwner().AddEffect(Permanent, Intelligence, Increment, -2);
		GetOwner().AddEffect(Permanent, Agility, Increment, -1);
		DestroyObject(self);
	} ]
}