{
	Init[ (s)
	{
		SetName(1663);
		SetShortName(1664);
		SetUsable(true);
		SetUseText(1665);
		SetCost( 70 );
		SetMarketValue( 25 );
		SetItemDescription(1666);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		curMagicka = GetOwner().GetMagicka() + 30;
		GetOwner().SetMagicka( curMagicka);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}