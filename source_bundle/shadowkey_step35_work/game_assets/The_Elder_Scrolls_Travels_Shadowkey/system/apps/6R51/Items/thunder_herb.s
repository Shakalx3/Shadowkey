{
	Init[ (s)
	{
		SetName(1744);
		SetShortName(1745);
		SetUsable( true );
		SetUseText(1630);
		SetCost( 310 );
		SetMarketValue( 109 );
		SetItemDescription(1746);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, Damage, Increment, 20, 30);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}