{
	Init[()
	{
		SetName(3264);
		SetID("skey11");
		SetUsable(true);
		SetUseText(3264);
		SetIcon(218);
		SetItemDescription(3264);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}