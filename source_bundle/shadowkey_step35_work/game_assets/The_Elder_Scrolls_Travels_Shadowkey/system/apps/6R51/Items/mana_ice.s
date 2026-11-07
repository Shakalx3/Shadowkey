{
	Init[ (s)
	{
		SetName(1667);
		SetShortName(1668);
		SetUsable( true );
		SetUseText(1669);
		SetCost( 170 );
		SetMarketValue( 60 );
		SetItemDescription(1670);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		curMagicka = GetOwner().GetMagicka();
		GetOwner().SetMagicka( curMagicka + 50 );
		DestroyObject(self);
	} ]
}