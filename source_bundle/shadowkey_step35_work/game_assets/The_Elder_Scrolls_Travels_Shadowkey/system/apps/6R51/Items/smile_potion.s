{
	Init[ (s)
	{
		SetName(1727);
		SetShortName(1728);
		SetUsable( true );
		SetUseText(1729);
		SetCost( 180 );
		SetMarketValue( 63 );
		SetItemDescription(1730);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, Personality, Increment, 20, 120);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}