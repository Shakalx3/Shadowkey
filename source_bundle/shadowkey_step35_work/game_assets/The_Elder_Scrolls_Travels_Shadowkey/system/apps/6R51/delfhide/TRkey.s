{
	Init[()
	{
		SetName(3607);
		SetID("TRkey");
		SetUsable(true);
		SetShortName(3607);
		SetUseText(3608);
		SetIcon(218);
		SetItemDescription(3607);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}