{
	Init[()
	{
		SetName(3269);
		SetID("skey6");
		SetUsable(true);
		SetUseText(3269);
		SetIcon(218);
		SetItemDescription(3269);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}