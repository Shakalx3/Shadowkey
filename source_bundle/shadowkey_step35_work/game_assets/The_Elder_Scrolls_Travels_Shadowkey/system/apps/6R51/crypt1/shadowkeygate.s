{
	saved_Skey1[0]
	saved_Skey2[0]
	saved_Skey3[0]
	saved_Skey4[0]
	saved_Skey5[0]
	saved_Skey6[0]
	saved_Skey7[0]
	saved_Skey8[0]
	saved_Skey9[0]
	saved_Skey10[0]
	saved_Skey11[0]
	saved_SkeyMenu[0]

	Init[()
	{
		ClearMenu();
		AddStaticItem(614);
		AddStaticItem(179, false);
		AddMenuItem(637, "Lock1");
		AddMenuItem(445, "MenuQuit");

		saved_SkeyMenu = 0;

		SkeyA = GetPlayer().FindInventory("skey1");
		if(SkeyA != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyB = GetPlayer().FindInventory("skey2");
		if(SkeyB != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyC = GetPlayer().FindInventory("skey3");
		if(SkeyC != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyD = GetPlayer().FindInventory("skey4");
		if(SkeyD != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyE = GetPlayer().FindInventory("skey5");
		if(SkeyE != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyF = GetPlayer().FindInventory("skey6");
		if(SkeyF != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyG = GetPlayer().FindInventory("skey7");
		if(SkeyG != null)
		{
		saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyH = GetPlayer().FindInventory("skey8");
		if(SkeyH != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyI = GetPlayer().FindInventory("skey9");
		if(SkeyI != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyJ = GetPlayer().FindInventory("skey10");
		if(SkeyJ != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}

		SkeyK = GetPlayer().FindInventory("skey11");
		if(SkeyK != null)
		{
			saved_SkeyMenu = saved_SkeyMenu + 1;
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Lock1[()
	{
		NoMenuOption = 1;
		skey1 = GetPlayer().FindInventory("skey1");
		skey2 = GetPlayer().FindInventory("skey2");
		skey3 = GetPlayer().FindInventory("skey3");
		skey4 = GetPlayer().FindInventory("skey4");
		skey5 = GetPlayer().FindInventory("skey5");
		skey6 = GetPlayer().FindInventory("skey6");
		skey7 = GetPlayer().FindInventory("skey7");
		skey8 = GetPlayer().FindInventory("skey8");
		skey9 = GetPlayer().FindInventory("skey9");
		skey10 = GetPlayer().FindInventory("skey10");
		skey11 = GetPlayer().FindInventory("skey11");
		if( skey1 != null or skey2 != null or skey3 != null or skey4 != null or skey5 != null or skey6 != null or skey7 != null or skey8 != null or skey9 != null or skey10 != null or skey11 != null )
		{
			if(saved_SkeyMenu < 8)
			{
				ClearMenu();
				AddStaticItem(617);
				AddStaticItem(179, false);
				if(saved_Skey1 = 0)
				{
					if(skey1 != null)
					{
						AddMenuItem(618, "WhichKey1a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey2 = 0)
				{
					if(skey2 != null)
					{
						AddMenuItem(619, "WhichKey2a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey3 = 0)
				{
					if(skey3 != null)
					{
						AddMenuItem(620, "WhichKey3a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey4 = 0)
				{
					if(skey4 != null)
					{
						AddMenuItem(621, "WhichKey4a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey5 = 0)
				{
					if(skey5 != null)
					{
						AddMenuItem(622, "WhichKey5a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey6 = 0)
				{
					if(skey6 != null)
					{
						AddMenuItem(623, "WhichKey6a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey7 = 0)
				{
					if(skey7 != null)
					{
						AddMenuItem(624, "WhichKey7a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey8 = 0)
				{
					if(skey8 != null)
					{
						AddMenuItem(625, "WhichKey8a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey9 = 0)
				{
					if(skey9 != null)
					{
						AddMenuItem(626, "WhichKey9a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey10 = 0)
				{
					if(skey10 != null)
					{
						AddMenuItem(627, "WhichKey10a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey11 = 0)
				{
					if(skey11 != null)
					{
						AddMenuItem(628, "WhichKey11a");
						NoMenuOption = 0;
					}
				}
				if(NoMenuOption = 1)
				{
					AddMenuItem(629, "MenuQuit");
				}
			}
			else
			{
				ClearMenu();
				AddStaticItem(617);
				AddStaticItem(179, false);
				if(saved_Skey1 = 0)
				{
					if(skey1 != null)
					{
						AddMenuItem(618, "WhichKey1a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey2 = 0)
				{
					if(skey2 != null)
					{
						AddMenuItem(619, "WhichKey2a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey3 = 0)
				{
					if(skey3 != null)
					{
						AddMenuItem(620, "WhichKey3a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey4 = 0)
				{
					if(skey4 != null)
					{
						AddMenuItem(621, "WhichKey4a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey5 = 0)
				{
					if(skey5 != null)
					{
						AddMenuItem(622, "WhichKey5a");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey6 = 0)
				{
					if(skey6 != null)
					{
						AddMenuItem(623, "WhichKey6a");
						NoMenuOption = 0;
					}
				}
				AddMenuItem(3918, "AnotherSkeyPage");
			}
		}
		else
		{
			ClearMenu();
			AddStaticItem(630);
			AddStaticItem(179, false);
			AddMenuItem(631, "MenuQuit");
		}
	}]

	AnotherSkeyPage[()
	{
		skey7 = GetPlayer().FindInventory("skey7");
		skey8 = GetPlayer().FindInventory("skey8");
		skey9 = GetPlayer().FindInventory("skey9");
		skey10 = GetPlayer().FindInventory("skey10");
		skey11 = GetPlayer().FindInventory("skey11");

		ClearMenu();
		AddStaticItem(617);
		AddStaticItem(179, false);

		if(saved_Skey7 = 0)
		{
			if(skey7 != null)
			{
				AddMenuItem(624, "WhichKey7a");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey8 = 0)
		{
			if(skey8 != null)
			{
				AddMenuItem(625, "WhichKey8a");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey9 = 0)
		{
			if(skey9 != null)
			{
				AddMenuItem(626, "WhichKey9a");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey10 = 0)
		{
			if(skey10 != null)
			{
				AddMenuItem(627, "WhichKey10a");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey11 = 0)
		{
			if(skey11 != null)
			{
				AddMenuItem(628, "WhichKey11a");
				NoMenuOption = 0;
			}
		}
		if(NoMenuOption = 1)
		{
			AddMenuItem(629, "MenuQuit");
		}
		AddMenuItem(3281, "Lock1");
	}]

	WhichKey1a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey1 = 1;
	}]

	WhichKey2a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey2 = 2;
	}]

	WhichKey3a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey3 = 3;
	}]

	WhichKey4a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey4 = 4;
	}]

	WhichKey5a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey5 = 5;
	}]

	WhichKey6a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey6 = 6;
	}]

	WhichKey7a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey7 = 7;
	}]

	WhichKey8a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey8 = 8;
	}]

	WhichKey9a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey9 = 9;
	}]

	WhichKey10a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey10 = 10;
	}]

	WhichKey11a[()
	{
		ClearMenu();
		AddStaticItem(632);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock2");
		saved_Skey11 = 11;
	}]

	Lock2[()
	{
		NoMenuOption = 1;
		skey1 = GetPlayer().FindInventory("skey1");
		skey2 = GetPlayer().FindInventory("skey2");
		skey3 = GetPlayer().FindInventory("skey3");
		skey4 = GetPlayer().FindInventory("skey4");
		skey5 = GetPlayer().FindInventory("skey5");
		skey6 = GetPlayer().FindInventory("skey6");
		skey7 = GetPlayer().FindInventory("skey7");
		skey8 = GetPlayer().FindInventory("skey8");
		skey9 = GetPlayer().FindInventory("skey9");
		skey10 = GetPlayer().FindInventory("skey10");
		skey11 = GetPlayer().FindInventory("skey11");
		if( skey1 != null or skey2 != null or skey3 != null or skey4 != null or skey5 != null or skey6 != null or skey7 != null or skey8 != null or skey9 != null or skey10 != null or skey11 != null )
		{
			if(saved_SkeyMenu < 8)
			{
				ClearMenu();
				AddStaticItem(634);
				AddStaticItem(179, false);
				if(saved_Skey1 = 0)
				{
					if(skey1 != null)
					{
						AddMenuItem(618, "WhichKey1b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey2 = 0)
				{
					if(skey2 != null)
					{
						AddMenuItem(619, "WhichKey2b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey3 = 0)
				{
					if(skey3 != null)
					{
						AddMenuItem(620, "WhichKey3b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey4 = 0)
				{
					if(skey4 != null)
					{
						AddMenuItem(621, "WhichKey4b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey5 = 0)
				{
					if(skey5 != null)
					{
						AddMenuItem(622, "WhichKey5b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey6 = 0)
				{
					if(skey6 != null)
					{
						AddMenuItem(623, "WhichKey6b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey7 = 0)
				{
					if(skey7 != null)
					{
						AddMenuItem(624, "WhichKey7b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey8 = 0)
				{
					if(skey8 != null)
					{
						AddMenuItem(625, "WhichKey8b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey9 = 0)
				{
					if(skey9 != null)
					{
						AddMenuItem(626, "WhichKey9b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey10 = 0)
				{
					if(skey10 != null)
					{
						AddMenuItem(627, "WhichKey10b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey11 = 0)
				{
					if(skey11 != null)
					{
						AddMenuItem(628, "WhichKey11b");
						NoMenuOption = 0;
					}
				}
				if(NoMenuOption = 1)
				{
					AddMenuItem(629, "MenuQuit");
				}
			}
			else
			{
				ClearMenu();
				AddStaticItem(634);
				AddStaticItem(179, false);
				if(saved_Skey1 = 0)
				{
					if(skey1 != null)
					{
						AddMenuItem(618, "WhichKey1b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey2 = 0)
				{
					if(skey2 != null)
					{
						AddMenuItem(619, "WhichKey2b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey3 = 0)
				{
					if(skey3 != null)
					{
						AddMenuItem(620, "WhichKey3b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey4 = 0)
				{
					if(skey4 != null)
					{
						AddMenuItem(621, "WhichKey4b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey5 = 0)
				{
					if(skey5 != null)
					{
						AddMenuItem(622, "WhichKey5b");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey6 = 0)
				{
					if(skey6 != null)
					{
						AddMenuItem(623, "WhichKey6b");
						NoMenuOption = 0;
					}
				}
				AddMenuItem(3918, "AnotherSkeyPage1");
			}
		}
		else
		{
			ClearMenu();
			AddStaticItem(630);
			AddStaticItem(179, false);
			AddMenuItem(631, "MenuQuit");
		}
	}]

	AnotherSkeyPage1[()
	{
		skey7 = GetPlayer().FindInventory("skey7");
		skey8 = GetPlayer().FindInventory("skey8");
		skey9 = GetPlayer().FindInventory("skey9");
		skey10 = GetPlayer().FindInventory("skey10");
		skey11 = GetPlayer().FindInventory("skey11");

		ClearMenu();
		AddStaticItem(617);
		AddStaticItem(179, false);

		if(saved_Skey7 = 0)
		{
			if(skey7 != null)
			{
				AddMenuItem(624, "WhichKey7b");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey8 = 0)
		{
			if(skey8 != null)
			{
				AddMenuItem(625, "WhichKey8b");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey9 = 0)
		{
			if(skey9 != null)
			{
				AddMenuItem(626, "WhichKey9b");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey10 = 0)
		{
			if(skey10 != null)
			{
				AddMenuItem(627, "WhichKey10b");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey11 = 0)
		{
			if(skey11 != null)
			{
				AddMenuItem(628, "WhichKey11b");
				NoMenuOption = 0;
			}
		}
		if(NoMenuOption = 1)
		{
			AddMenuItem(629, "MenuQuit");
		}
		AddMenuItem(3281, "Lock2");
	}]

	WhichKey1b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey1 = 1;
	}]

	WhichKey2b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey2 = 2;
	}]

	WhichKey3b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey3 = 3;
	}]

	WhichKey4b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey4 = 4;
	}]

	WhichKey5b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey5 = 5;
	}]

	WhichKey6b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey6 = 6;
	}]

	WhichKey7b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey7 = 7;
	}]

	WhichKey8b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey8 = 8;
	}]

	WhichKey9b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey9 = 9;
	}]

	WhichKey10b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey10 = 10;
	}]

	WhichKey11b[()
	{
		ClearMenu();
		AddStaticItem(635);
		AddStaticItem(179, false);
		AddMenuItem(633, "Lock3");
		saved_Skey11 = 11;
	}]

	Lock3[()
	{
		NoMenuOption = 1;
		skey1 = GetPlayer().FindInventory("skey1");
		skey2 = GetPlayer().FindInventory("skey2");
		skey3 = GetPlayer().FindInventory("skey3");
		skey4 = GetPlayer().FindInventory("skey4");
		skey5 = GetPlayer().FindInventory("skey5");
		skey6 = GetPlayer().FindInventory("skey6");
		skey7 = GetPlayer().FindInventory("skey7");
		skey8 = GetPlayer().FindInventory("skey8");
		skey9 = GetPlayer().FindInventory("skey9");
		skey10 = GetPlayer().FindInventory("skey10");
		skey11 = GetPlayer().FindInventory("skey11");
		if( skey1 != null or skey2 != null or skey3 != null or skey4 != null or skey5 != null or skey6 != null or skey7 != null or skey8 != null or skey9 != null or skey10 != null or skey11 != null )
		{
			if(saved_SkeyMenu < 8)
			{
				ClearMenu();
				AddStaticItem(616);
				AddStaticItem(617);
				AddStaticItem(179, false);
				if(saved_Skey1 = 0)
				{
					if(skey1 != null)
					{
						AddMenuItem(618, "WhichKey1c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey2 = 0)
				{
					if(skey2 != null)
					{
						AddMenuItem(619, "WhichKey2c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey3 = 0)
				{
					if(skey3 != null)
					{
						AddMenuItem(620, "WhichKey3c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey4 = 0)
				{
					if(skey4 != null)
					{
						AddMenuItem(621, "WhichKey4c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey5 = 0)
				{
					if(skey5 != null)
					{
						AddMenuItem(622, "WhichKey5c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey6 = 0)
				{
					if(skey6 != null)
					{
						AddMenuItem(623, "WhichKey6c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey7 = 0)
				{
					if(skey7 != null)
					{
						AddMenuItem(624, "WhichKey7c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey8 = 0)
				{
					if(skey8 != null)
					{
						AddMenuItem(625, "WhichKey8c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey9 = 0)
				{
					if(skey9 != null)
					{
						AddMenuItem(626, "WhichKey9c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey10 = 0)
				{
					if(skey10 != null)
					{
						AddMenuItem(627, "WhichKey10c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey11 = 0)
				{
					if(skey11 != null)
					{
						AddMenuItem(628, "WhichKey11c");
						NoMenuOption = 0;
					}
				}
				if(NoMenuOption = 1)
				{
					AddMenuItem(629, "MenuQuit");
				}
			}
			else
			{
				ClearMenu();
				AddStaticItem(616);
				AddStaticItem(617);
				AddStaticItem(179, false);
				if(saved_Skey1 = 0)
				{
					if(skey1 != null)
					{
						AddMenuItem(618, "WhichKey1c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey2 = 0)
				{
					if(skey2 != null)
					{
						AddMenuItem(619, "WhichKey2c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey3 = 0)
				{
					if(skey3 != null)
					{
						AddMenuItem(620, "WhichKey3c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey4 = 0)
				{
					if(skey4 != null)
					{
						AddMenuItem(621, "WhichKey4c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey5 = 0)
				{
					if(skey5 != null)
					{
						AddMenuItem(622, "WhichKey5c");
						NoMenuOption = 0;
					}
				}
				if(saved_Skey6 = 0)
				{
					if(skey6 != null)
					{
						AddMenuItem(623, "WhichKey6c");
						NoMenuOption = 0;
					}
				}
				AddMenuItem(3918, "AnotherSkeyPage2");
			}
		}
		else
		{
			ClearMenu();
			AddStaticItem(630);
			AddStaticItem(179, false);
			AddMenuItem(631, "MenuQuit");
		}
	}]

	AnotherSkeyPage2[()
	{
		skey7 = GetPlayer().FindInventory("skey7");
		skey8 = GetPlayer().FindInventory("skey8");
		skey9 = GetPlayer().FindInventory("skey9");
		skey10 = GetPlayer().FindInventory("skey10");
		skey11 = GetPlayer().FindInventory("skey11");

		ClearMenu();
		AddStaticItem(617);
		AddStaticItem(179, false);

		if(saved_Skey7 = 0)
		{
			if(skey7 != null)
			{
				AddMenuItem(624, "WhichKey7c");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey8 = 0)
		{
			if(skey8 != null)
			{
				AddMenuItem(625, "WhichKey8c");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey9 = 0)
		{
			if(skey9 != null)
			{
				AddMenuItem(626, "WhichKey9c");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey10 = 0)
		{
			if(skey10 != null)
			{
				AddMenuItem(627, "WhichKey10c");
				NoMenuOption = 0;
			}
		}
		if(saved_Skey11 = 0)
		{
			if(skey11 != null)
			{
				AddMenuItem(628, "WhichKey11c");
				NoMenuOption = 0;
			}
		}
		if(NoMenuOption = 1)
		{
			AddMenuItem(629, "MenuQuit");
		}
		AddMenuItem(3281, "Lock3");
	}]

	WhichKey1c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey1 = 1;
	}]

	WhichKey2c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey2 = 2;
	}]

	WhichKey3c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey3 = 3;
	}]

	WhichKey4c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey4 = 4;
	}]

	WhichKey5c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey5 = 5;
	}]

	WhichKey6c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey6 = 6;
	}]

	WhichKey7c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey7 = 7;
	}]

	WhichKey8c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey8 = 8;
	}]

	WhichKey9c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey9 = 9;
	}]

	WhichKey10c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey10 = 10;
	}]

	WhichKey11c[()
	{
		ClearMenu();
		AddStaticItem(636);
		AddStaticItem(179, false);
		AddMenuItem(637, "GateOpen");
		saved_Skey11 = 11;
	}]

	GateOpen[()
	{
		ClearMenu();
		AddStaticItem(638);
		AddStaticItem(179, false);
		AddMenuItem(386, "Done");
	}]

	Done[()
	{
		Reward = saved_Skey1 + saved_Skey2 + saved_Skey3 + saved_Skey4 + saved_Skey5 + saved_Skey6 + saved_Skey7 + saved_Skey8 + saved_Skey9 + saved_Skey10 + saved_Skey11;
		if( Reward < 13 )
		{
			Loot = Level.CreateEntityScript( 301, "crypt1\\\\skchest1a", 8576 - 200, 3200, 0 + 300 );
			Loot.SetDestroy(true);
		}
		else
		{
			if( Reward < 26 )
			{
				Loot = Level.CreateEntityScript( 301, "crypt1\\\\skchest2a", 8576 - 200, 3200, 0 + 300 );
				Loot.SetDestroy(true);
			}
			else
			{
				if( Reward < 31 )
				{
					Loot = Level.CreateEntityScript( 301, "crypt1\\\\skchest3a", 8576 - 200, 3200, 0 + 300 );
					Loot.SetDestroy(true);
				}
			}
		}
		QuitAndDestroyOpener();
		Level.saved_Swdoor=1;
	}]
}