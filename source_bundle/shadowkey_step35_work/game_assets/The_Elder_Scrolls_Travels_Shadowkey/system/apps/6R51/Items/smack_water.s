{
        Init[ (s)
        {
                SetUseText(907);
                SetUsable( true );
                SetName(1724);
                SetShortName(1725);
                SetCost( 225 );
		SetMarketValue( 79 );
		SetItemDescription(1726);
		SetIcon(210);
        } ]

    OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, Strength, Increment, 10, 120);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}