{
	Init[ (s)
	{
		SetName(727);
		SetShortName(1599);
		SetUseText(728);
		SetUsable( true );
		SetMarketValue( 0 );
		SetItemDescription(1600);
		SetIcon(211);
	} ]

    OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Permanent, Endurance, Increment, 5);
		GetOwner().AddEffect(Permanent, Agility, Increment, -2);
		GetOwner().AddEffect(Permanent, Intelligence, Increment, -1);
		//DestroyObject(self);
	} ]
}