{
	Init[ (s)
	{
		SetName(911);
		SetShortName(1747);
		SetUseText(912);
		SetUsable( true );
		SetCost( 20 );
		SetMarketValue( 7 );
		SetItemDescription(1748);
		SetIcon(212);
	} ]

    OnUse[ (s)
	{
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue + 20 );
		curMagicka = GetOwner().GetMagicka();
		GetOwner().SetMagicka( curMagicka + 10 );
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}