{
	Init[ (s)
	{
		Rogurin = Level.GetEntity("rogurin");
		if( Rogurin.MetPlayerBefore = 0 )
		{
			AddStaticItem(1278);
			AddStaticItem(179, false);
			AddMenuItem(1279, "IntroWhatHappened");
			AddMenuItem(200, "Quit");
			Rogurin.MetPlayerBefore = 1;
		}
		else
		{
			ClearMenu();
			if( GetPlayer().QuestAssigned(7) )
			{
				if( GetPlayer().QuestSolved(7) )
				{
					AddStaticItem(1280);
					AddStaticItem(179, false);
					AddMenuItem(1281, "WouldThisBeIt");
				}
				else
				{
					AddStaticItem(1282);
					AddStaticItem(179, false);
					AddMenuItem(1283, "Quit");
				}
			}
			else
			{
				AddStaticItem(1284);
				AddStaticItem(179, false);
				AddMenuItem(1285, "WhatDoYouNeed");
				AddMenuItem(1286, "Quit");
			}
		}
	} ]

	IntroWhatHappened[ (s)
	{
		ClearMenu();
		AddStaticItem(1287);
		AddStaticItem(179, false);
		AddMenuItem(182, "IntroMore1");
	} ]

	IntroMore1[ (s)
	{
		ClearMenu();
		AddStaticItem(1288);
		AddStaticItem(179, false);
		AddMenuItem(182, "IntroMore2");
	} ]

	IntroMore2[ (s)
	{
		ClearMenu();
		AddStaticItem(1289);
		AddStaticItem(179, false);
		AddMenuItem(182, "IntroMore3");
	} ]

	IntroMore3[ (s)
	{
		ClearMenu();
		AddStaticItem(1290);
		AddStaticItem(179, false);
		AddMenuItem(182, "IntroMore4");
	} ]

	IntroMore4[ (s)
	{
		ClearMenu();
		AddStaticItem(1291);
		AddStaticItem(179, false);
		AddMenuItem(182, "IntroMore5");
	} ]

	IntroMore5[ (s)
	{
		ClearMenu();
		AddStaticItem(1292);
		AddStaticItem(179, false);
		AddMenuItem(1293, "IntroMore6");
		AddMenuItem(200, "Quit");
	} ]

	IntroMore6[ (s)
	{
		ClearMenu();
		AddStaticItem(1294);
		AddStaticItem(179, false);
		AddMenuItem(1285, "WhatDoYouNeed");
		AddMenuItem(757, "Quit");
	} ]

	WhatDoYouNeed[ (s)
	{
		ClearMenu();
		if( GetPlayer().QuestSolved(7) )
		{
			AddStaticItem(1295);
			AddStaticItem(179, false);
			AddMenuItem(1281, "WouldThisBeIt");
		}
		else
		{
			AddStaticItem(1296);
			AddStaticItem(179, false);
			AddMenuItem(1297, "WhereMightItBe");
		}
	} ]

	WhereMightItBe[ (s)
	{
		if(GetPlayer().FindInventory("papers2") != null)
		{
		ClearMenu();
		AddStaticItem(1298);
		AddStaticItem(179, false);
		AddMenuItem(3670, "WouldThisBeIt");
		}
		else
		{
		ClearMenu();
		AddStaticItem(1298);
		AddStaticItem(179, false);
		AddMenuItem(182, "WhereMightItBeMore");
		}
	} ]

	WhereMightItBeMore[ (s)
	{
		ClearMenu();
		AddStaticItem(1299);
		AddStaticItem(179, false);
		AddMenuItem(1300, "Quit");
		GetPlayer().SetQuestAssigned(7);
	} ]

	WouldThisBeIt[ (s)
	{
		ClearMenu();
		AddStaticItem(1301);
		AddStaticItem(1302);
		AddStaticItem(1303);
		AddStaticItem(1304);
		AddStaticItem(179, false);
		GetPlayer().AddExperience(320);
		AddMenuItem(528, "Quit");
		Item = Level.CreateEntity( 648 );
		GetPlayer().PickupItem( Item );
		Rogurin = Level.GetEntity("rogurin");
		Rogurin.DestroyObjectMirror(Rogurin);
		GetPlayer().SetQuestCompleted(7);
		Letter = GetPlayer().FindInventory("papers2");
		GetPlayer().RemoveItem(Letter);
	} ]
}