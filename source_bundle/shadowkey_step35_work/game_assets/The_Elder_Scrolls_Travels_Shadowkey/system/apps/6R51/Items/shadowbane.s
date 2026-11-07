{
	Init[ (s)
	{
		SetName(1698);
		SetShortName(1699);
		SetUsable( true );
		SetUseText(1700);
		SetCost( 1100 );
		SetMarketValue( 385 );
		SetItemDescription(1701);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}