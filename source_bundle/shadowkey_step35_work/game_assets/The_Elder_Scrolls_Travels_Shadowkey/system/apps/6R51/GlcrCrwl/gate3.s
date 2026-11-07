{
	Init[()
	{
		AddStaticItem(3673);
		AddStaticItem(179, false);
		if(Level.GetEntity("box3").saved_Gate = 0)
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
		Level.GetEntity("box3").OnReallyUsed1();
		Level.GetEntity("box3").MirrorMethod("OnReallyUsed1");
	}]

	Open2[()
	{
		Level.GetEntity("box3").OnReallyUsed2();
		Level.GetEntity("box3").MirrorMethod("OnReallyUsed2");
	}]
}