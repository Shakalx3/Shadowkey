{
	Init[ (s)
	{
		SetName(1613);
		SetShortName(1614);
		SetUsable(true);
		SetUseText(935);
		SetID("bread");
		SetCost( 4 );
		SetMarketValue( 1 );
		SetItemDescription(1615);
		SetIcon( 212 );
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue + 50 );
		DestroyObject(self);
	} ]
}