{
	Init[ (s)
	{
		SetName(1683);
		SetShortName(1684);
		SetUsable( true );
		SetUseText(1685);
		SetCost( 190 );
		SetMarketValue( 67 );
		SetItemDescription(1686);
		SetIcon(210);
		SetID("warpnt");
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, ArmorValue, Increment, 5, 120);
		DestroyObject(self);
	} ]
}