{
	Init[ (s)
	{
		SetName(1609);
		SetShortName(1610);
		SetUsable( true );
		SetUseText(1611);
		SetCost( 550 );
		SetMarketValue( 193 );
		SetItemDescription(1612);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, Will, Increment, 40, 30);
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue - 20 );
		DestroyObject(self);
	} ]
}