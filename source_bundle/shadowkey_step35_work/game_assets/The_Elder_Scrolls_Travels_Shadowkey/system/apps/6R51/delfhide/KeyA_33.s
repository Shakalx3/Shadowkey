{
	Init[ (s)
	{
		SetUseText(855);
		SetName(855);
		SetShortName(855);
		SetID("keya");
		SetIcon( 218 );
		SetCanDrop(false);
		SetUsable(true);
		SetItemDescription(4012);
	} ]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]

}
