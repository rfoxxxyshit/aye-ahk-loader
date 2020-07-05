ConfigOpen()
{
	run, notepad.exe "C:\AYE\config.ini"
}
ShowAbout()
{
	Logging(1,"Building About GUI...")
    IniRead, language, C:\AYE\config.ini, settings, language
	IfNotExist, %A_TEMP%\cheats.ini
	{
		cheatsCount = "Не удалось загрузить"
	} else {
		IniRead, cheatlist, %A_TEMP%\cheats.ini, cheatlist, cheatlist
		StringSplit, cheatss, cheatlist, |
		cheatsCount := cheatss0
	}
	Gui, About:New
	Gui, About:Font, s9
    if (language = "en") 
    { 
	    Gui, About:Show, w315 h155, %script% v%version% | About
        Gui, About:Add, Text, x112 y9 w100 h20 +Center, %script%
        Gui, About:Add, Text, x59 y29 w200 h30 +Center, AYE loader with open-source for AYE boys.
	    Gui, About:Add, Link, x59 y69 w200 h20 +Center, Developers: <a href="http://m4x3r.me/">m4x3r1337</a> and <a href="http://rf0x3d.su/">rf0x1d</a>
	    Gui, About:Add, Text, x59 y89 w200 h20 +Center, Current cheats count: %cheatsCount%
    }   
    if (language = "ru") 
    { 
	    Gui, About:Show, w315 h155, %script% v%version% | Инфо
        Gui, About:Add, Text, x112 y9 w100 h20 +Center, %script%
        Gui, About:Add, Text, x59 y29 w200 h30 +Center, АУЕ лоадер для АУЕ пацанов с открытым исходным кодом.
	    Gui, About:Add, Link, x59 y69 w200 h20 +Center, Разработчики: <a href="http://m4x3r.me/">m4x3r1337</a> and <a href="http://rf0x3d.su/">rf0x1d</a>
	    Gui, About:Add, Text, x59 y89 w200 h20 +Center, Текущее кол-во читов: %cheatsCount%
    }
	Gui, About:Add, Link, x50 y115 w100 h20 +Center, <a href="https://github.com/rfoxxxyshit/aye-ahk-loader">Github</a>
	Gui, About:Add, Link, x210 y115 w100 h20 +Center, <a href="https://qiwi.me/rfoxxxyshit">Donate :)</a>
	Logging(1,"done.")
	return	
}
KillCsgo()
{
	Loop 2
	{
		Logging(1,"Killing csgo...")
		Process, close, csgo.exe
		GuiControl,, Pbar, +50
		Sleep, 1550
	}
	GuiControl,, Pbar, 0
}
RunAsAdmin()
{
	if (A_IsAdmin = false) 
	{ 
		Logging(1,"Restarting as admin...")
   		Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel 
	}
}
