{
	Init[()
	{
		AddStaticItem(3677);
		AddStaticItem(179, false);
		if(Level.GetEntity("box7").saved_Gate = 0)
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
		Level.GetEntity("box7").OnReallyUsed1();
		Level.GetEntity("box7").MirrorMethod("OnReallyUsed1");
	}]

	Open2[()
	{
		Level.GetEntity("box7").OnReallyUsed2();
		Level.GetEntity("box7").MirrorMethod("OnReallyUsed2");
	}]
}