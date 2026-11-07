{
	Init[ (s)
	{
		SetName(1759);
		SetShortName(1760);
		SetUsable( true );
		SetUseText(1729);
		SetCost( 20 );
		SetMarketValue( 7 );
		SetItemDescription(1761);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		curFatigue = GetOwner().GetFatigue() - 50;
		if (curFatigue > -1)
		{
			GetOwner().SetFatigue( curFatigue );
			curMagicka = GetOwner().GetMagicka();
			GetOwner().SetMagicka( curMagicka + 25 );
			GetOwner().PlaySound(87);
			DestroyObject(self);
		}
		else
		{
			DisplayPopup("Must have at least 50 fatigue!");
		}
	} ]
}