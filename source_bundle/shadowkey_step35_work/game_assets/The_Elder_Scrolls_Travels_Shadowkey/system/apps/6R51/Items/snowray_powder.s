{
	Init[ (s)
	{
		SetName(1731);
		SetShortName(1732);
		SetUsable( true );
		SetUseText(1733);
		SetCost( 4700 );
		SetMarketValue( 1645 );
		SetItemDescription(3041);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().SetSpellEffect(9, 7680); //snowray, 30 secs
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}