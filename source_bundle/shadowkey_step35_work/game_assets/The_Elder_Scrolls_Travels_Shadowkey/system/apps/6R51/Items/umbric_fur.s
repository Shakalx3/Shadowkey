{
	Init[ (s)
	{
		SetName(1762);
		SetShortName(1763);
		SetUsable( true );
		SetUseText(1764);
		SetCost( 420 );
		SetMarketValue( 147 );
		SetItemDescription(1765);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, Attack, Increment, 2, 120);
		GetOwner().AddEffect(Timed, Defense, Increment, 2, 120);
		GetOwner().AddEffect(Timed, ArmorValue, Increment, 2, 120);
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue - 50 );
		DestroyObject(self);
	} ]
}