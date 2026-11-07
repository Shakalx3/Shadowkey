{
	Init[()
	{
		if(GetPlayer().saved_EndGame = 1)
		{
			whichItem = Random(1,100);
			if( whichItem < 26 )
			{
				AddStaticItem(3962);
				AddStaticItem(179, false);
				AddMenuItem(3963, "Quit");
			}
			else
			{
				if( whichItem < 51 )
				{
					AddStaticItem(3966);
					AddStaticItem(179, false);
					AddMenuItem(3967, "Quit");
				}
				else
				{
					if( whichItem < 76 )
					{
						AddStaticItem(3964);
						AddStaticItem(179, false);
						AddMenuItem(3965, "Quit");
					}
					else
					{
						AddStaticItem(3968);
						AddStaticItem(179, false);
						AddMenuItem(3963, "Quit");
					}
				}
			}
		}
		else
		{
			AddStaticItem(3763);
			AddStaticItem(179, false);
			AddMenuItem(834, "Quit");
		}
	}]
}