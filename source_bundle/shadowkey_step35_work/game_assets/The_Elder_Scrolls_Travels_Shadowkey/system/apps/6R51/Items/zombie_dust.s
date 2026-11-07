{
	Init[ (s)
	{
		SetName(1778);
		SetShortName(1779);
		SetUsable( true );
		SetUseText(1622);
		SetCost( 170 );
		SetMarketValue( 60 );
		SetItemDescription(1780);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, ArmorValue, Increment, 2, 30);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}