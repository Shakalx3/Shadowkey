{
	Init[ (s)
	{
		SetName(1587);
		SetShortName(1588);
		SetUsable( true );
		SetUseText(1589);
		SetCost( 1325 );
		SetMarketValue( 464 );
		SetItemDescription(1590);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().SetSpellEffect(5, 1600); //lethal strike
		GetOwner().PlaySound(87);
		//DestroyObject(self);
	} ]
}