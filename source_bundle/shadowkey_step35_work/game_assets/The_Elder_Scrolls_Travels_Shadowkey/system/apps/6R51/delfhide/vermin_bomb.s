{
	Init[ (s)
	{
		SetName(930);
		SetShortName(1766);
		SetUsable( true );
		SetUseText(1767);
		SetCost( 500 );
		SetMarketValue( 175 );
		SetItemDescription(1768);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Permanent, Health, Increment, Random(-2, -12));
		CastAzraWrath();
		DestroyObject(self);
	} ]
}