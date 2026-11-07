{
	Init[ (s)
	{
		SetName(1676);
		SetShortName(1677);
		SetUsable(true);
		SetUseText(912);
		SetCost( 2 );
		SetMarketValue( 1 );
		SetItemDescription(1678);
		SetIcon( 212 );
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue + 30 );
		DestroyObject(self);
	} ]
}