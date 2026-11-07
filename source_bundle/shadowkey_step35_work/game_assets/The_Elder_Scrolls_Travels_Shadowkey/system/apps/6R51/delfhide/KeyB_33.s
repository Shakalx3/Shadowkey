{
	Init[ (s)
	{
		SetUseText(856);
		SetName(857);
		SetShortName(857);
		SetID("keyb");
		SetIcon( 218 );
		SetCanDrop(false);
		SetUsable(true);
		SetItemDescription(4013);
	} ]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}