{
	Init[()
	{
		if( Level.saved_CountMonster = 0 ){ Fight(1); }
		if( Level.saved_CountMonster = 1 ){ Fight(2); }
		if( Level.saved_CountMonster = 2 ){ Fight(3); }
		if( Level.saved_CountMonster = 3 ){ Fight(4); }
		if( Level.saved_CountMonster = 4 ){ Fight(5); }
	}]

	Fight[ (Who)
	{
		switch(Who)
		{
			case 1
			{

				Quit();
				mon01 = Level.GetEntity("Mon01");
				mon01.SetPosition( 24192, 19609, -3300);
				Player = GetPlayer();
				Player.SetPosition(23168,20864,-3300);
				mon01.AiDetect();

			}
			case 2
			{
				Quit();
				mon02 = Level.GetEntity("Mon02");
				mon02.SetPosition( 24192, 19609, -3300);
				Player = GetPlayer();
				Player.SetPosition(23168,20864,-3300);
				mon02.AiDetect();
			}
			case 3
			{
				Quit();
				mon03 = Level.GetEntity("Mon03");
				mon03.SetPosition( 24192, 19609, -3300);
				Player = GetPlayer();
				Player.SetPosition(23168,20864,-3300);
				mon03.AiDetect();
			}
			case 4
			{
				Quit();
				mon04 = Level.GetEntity("Mon04");
				mon04.SetPosition( 24192, 19609, -3300);
				Player = GetPlayer();
				Player.SetPosition(23168,20864,-3300);
				mon04.AiDetect();
			}
			case 5
			{
				Quit();
				mon05 = Level.GetEntity("Mon05");
				mon05.SetPosition( 24192, 19609, -3300);
				Player = GetPlayer();
				Player.SetPosition(23168,20864,-3300);
				mon05.AiDetect();
			}
		}

	}]
}
