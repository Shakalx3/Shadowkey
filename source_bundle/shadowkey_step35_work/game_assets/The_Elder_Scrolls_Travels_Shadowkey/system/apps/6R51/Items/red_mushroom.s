{
	Init[ (s)
	{
		SetName(1691);
		SetShortName(1692);
		SetUsable( true );
		SetUseText(1603);
		SetCost( 448 );
		SetMarketValue( 157 );
		SetItemDescription(1693);
		SetIcon(212);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, MaxHealth, Increment, 50, 300);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}