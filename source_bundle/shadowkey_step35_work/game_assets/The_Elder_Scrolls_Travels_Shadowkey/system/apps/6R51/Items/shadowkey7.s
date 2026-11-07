{
	Init[()
	{
		SetName(3270);
		SetID("skey7");
		SetUsable(true);
		SetUseText(3270);
		SetIcon(218);
		SetItemDescription(3270);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}