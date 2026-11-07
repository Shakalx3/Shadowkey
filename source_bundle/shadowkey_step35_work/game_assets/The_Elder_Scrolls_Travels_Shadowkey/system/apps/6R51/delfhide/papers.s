{
	Init[()
	{
		SetName(3601);
		SetID("papers");
		SetUsable(true);
		SetShortName(3601);
		SetUseText(3602);
		SetItemDescription(3601);
		SetIcon(218);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}