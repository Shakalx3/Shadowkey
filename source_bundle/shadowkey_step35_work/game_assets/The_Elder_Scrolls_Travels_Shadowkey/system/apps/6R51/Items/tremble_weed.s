{
	Init[ (s)
	{
		SetName(1752);
		SetShortName(1753);
		SetUsable( true );
		SetUseText(1754);
		SetCost( 188 );
		SetMarketValue( 66 );
		SetItemDescription(1755);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, Speed, Increment, 20, 30);
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue - 25 );
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}