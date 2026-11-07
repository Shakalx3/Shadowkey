{
	Init[ (s)
	{
		SetName(1660);
		SetShortName(1661);
		SetUsable( true );
		SetUseText(1622);
		SetCost( 175 );
		SetMarketValue( 61 );
		SetItemDescription(1662);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		//GetOwner().AddEffect(Timed, Lockpick, Increment, 5, 30);
		//GetOwner().AddEffect(Timed, DisarmTrap, Increment, 5, 30);
		GetOwner().PlaySound(87);
		GetOwner().SetSpellEffect(3, 1400); //LockPick&Disarm
		DestroyObject(self);
	} ]
}