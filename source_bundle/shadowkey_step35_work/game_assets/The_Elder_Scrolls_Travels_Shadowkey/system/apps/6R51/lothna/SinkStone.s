{
	Init[ ()
	{
		SetName(1950);
		SetShortName(3701);
		SetUseText(1951);
		SetUsable( true );
		SetItemDescription(1952);
		SetIcon(210);
	}]

	OnUse[ ()
	{
		GetOwner().PlaySound(87);
		UseStone();
	}]

	UseStone[ ()
	{
		GetPlayer().OpenMenu("lothna\\\\stone_menu");
	}]

}