{
	Init[ (s)
	{
		SetName(1694);
		SetShortName(1695);
		SetUsable( true );
		SetUseText(1696);
		SetCost( 1200 );
		SetMarketValue( 420 );
		SetItemDescription(1697);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Permanent, Health, Increment, Random(-12, -44));
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}