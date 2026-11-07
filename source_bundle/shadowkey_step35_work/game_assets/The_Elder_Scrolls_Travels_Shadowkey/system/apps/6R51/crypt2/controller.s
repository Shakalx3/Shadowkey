{
	Init[()
	{
		return;
	}]

	DelayReached[(s)
	{
		if(s = 0)
		{
			Delay(1, 1);
			Level.LightRect(11, 36, 14, 39, 64);
			PlaySound(83);
		}
		if(s = 1)
		{
			Delay(1, 2);
			Level.LightRect(19, 38, 22, 41, 64);
			PlaySound(83);
		}
		if(s = 2)
		{
			Delay(1, 3);
			Level.LightRect(26, 33, 29, 36, 64);
			PlaySound(83);
		}
		if(s = 3)
		{
			Delay(1, 4);
			Level.LightRect(26, 26, 29, 29, 64);
			PlaySound(83);
		}
		if(s = 4)
		{
			Delay(1, 5);
			Level.LightRect(19, 21, 22, 24, 64);
			PlaySound(83);
		}
		if(s = 5)
		{
			Delay(1, 6);
			Level.LightRect(11, 23, 14, 26, 64);
			PlaySound(83);
		}
		if(s = 6)
		{
			Delay(1, 7);
			Level.LightRect(7, 30, 10, 33, 64);
			PlaySound(83);
		}
		if(s = 7)
		{
			Umbra = Level.CreateEntity(274, 4480, 7808, 400);
			Umbra.Scale();
			Umbra.MirrorMethod("ClientFightUmbra");
			PlaySound(83);
		}
	}]
}