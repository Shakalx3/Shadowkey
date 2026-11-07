{
	Init[ (s)
	{
		SetName(1679);
		SetShortName(1680);
		SetUsable( true );
		SetUseText(1681);
		SetCost( 680 );
		SetMarketValue( 238 );
		SetItemDescription(1682);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		//GetOwner().AddEffect(Timed, ThiefLore, Increment, 20, 30);
		GetOwner().PlaySound(87);
		GetOwner().SetSpellEffect(3, 400); //LockPick&Disarm
		DestroyObject(self);
	} ]
}