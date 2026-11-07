{
	Init[ (s)
	{
		SetName(725);
		SetUseText(726);
		SetUsable(true);
		SetID("winebot");
		SetCost( 12 );
		SetItemDescription(4055);
		SetMarketValue( 4 );
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetPlayer().SetHealth( GetPlayer().GetHealth() + 15 );
		GetPlayer().SetFatigue( GetPlayer().GetFatigue() + 45 );
	} ]
}