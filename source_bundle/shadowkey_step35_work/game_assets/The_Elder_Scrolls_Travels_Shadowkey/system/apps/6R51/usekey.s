{
	Init[ (s)
	{
		AddStaticItem(3305);
		AddStaticItem(179, false);
		AddMenuItem(3306, "UseKey");
		AddMenuItem(3307, "MenuQuit");
	}]

	UseKey[ (s)
	{
		GetOpener().OpenDoor(" ");
		GetOpener().SetUsable(false);
		GetPlayer().OpenMenu("keycrumble");
		key = GetPlayer().FindInventory("skelkey");
		key.UseCharge();
	}]

	MenuQuit[ ()
	{
		//if (GetPlayer().IsMagicDoor(GetOpener()))
		//{
		//	GetOpener().DoMagicDamage();
		//}
		//Quit();
		GetOpener().MagicDamage();
	}]
}