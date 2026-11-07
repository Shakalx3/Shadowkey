{
	Init[ (s)
	{
		SetName(1772);
		SetShortName(1773);
		SetUsable( true );
		SetUseText(1774);
		SetCost( 220 );
		SetMarketValue( 77 );
		SetItemDescription(1775);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, Strength, Increment, 20, 30);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}