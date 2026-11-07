{
	Init[()
	{
		AddStaticItem(3675);
		AddStaticItem(179, false);
		if(Level.GetEntity("box5").saved_Gate = 0)
		{
			key = GetPlayer().FindInventory("frozen_key");
			if(key != null)
			{
				AddMenuItem(3955, "Open1");
			}
		}
		else
		{
			AddMenuItem(3956, "Open2");
		}
		AddMenuItem(386, "Quit");
	}]

	Open1[()
	{
		Level.GetEntity("box5").OnReallyUsed1();
		Level.GetEntity("box5").MirrorMethod("OnReallyUsed1");
	}]

	Open2[()
	{
		Level.GetEntity("box5").OnReallyUsed2();
		Level.GetEntity("box5").MirrorMethod("OnReallyUsed2");
	}]
}