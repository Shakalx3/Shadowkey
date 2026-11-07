{
	Init[ ()
	{
		AddStaticItem(3927);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		if(GetPlayer().FindInventory( "cellkey" ) != null)
		{
			AddMenuItem(3609, "Pick");
		}
		else
		{
			AddMenuItem(3556, "Pick");
		}
	}]

	Pick[ ()
	{
		if (GetPlayer().CanDisarmTrap(GetOpener().resistDisarm) = true)
		{
			GetOpener().LockPicked();
		}
		else
		{
			key = GetPlayer().FindInventory("cellkey");
			if (key != null)
			{
				GetOpener().Use_CellKey();
			}
			else
			{
				GetOpener().MagicDamage();
			}
		}
	}]
}