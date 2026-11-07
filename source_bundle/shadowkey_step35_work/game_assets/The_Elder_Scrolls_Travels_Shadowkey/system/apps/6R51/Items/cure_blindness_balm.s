{
	Init[ (s)
	{
		SetName(1616);
		SetShortName(1617);
		SetUsable( true );
		SetUseText(1618);
		SetID("c_blind");
		SetCost( 140 );
		SetMarketValue( 49 );
		SetItemDescription(1619);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().SetBlindness(false,0);
		DestroyObject(self);
	} ]
}