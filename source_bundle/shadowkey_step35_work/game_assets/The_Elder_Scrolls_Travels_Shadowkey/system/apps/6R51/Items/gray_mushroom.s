{
	Init[ (s)
	{
		SetName(1642);
		SetShortName(1643);
		SetUsable( true );
		SetUseText(1603);
		SetCost( 468 );
		SetMarketValue( 164 );
		SetItemDescription(1644);
		SetIcon(212);
	} ]

	OnUse[ (s)
	{
		GetPlayer().SetSpeed(GetPlayer().GetSpeed() + 1);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}