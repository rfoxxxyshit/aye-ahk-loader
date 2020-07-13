#include Lib\strings.ahk
#Include Lib\JSON.ahk


CheckUpdates()
{
	jsonStr := JSON.GetFromUrl("https://api.github.com/repos/rfoxxxyshit/aye-ahk-loader/releases/latest")
	if IsObject(jsonStr) 
	{
		MsgBox, % jsonStr[1]
		Return
	}
	if (jsonStr = "")
	Return
	obj := JSON.Parse(jsonStr)
	latest_release := obj.tag_name
	if (version != latest_release)
	{
		Logging(1,"A new version is available. Latest version: " latest_release)
		MsgBox, 68, %script%, %string_new_version%
		IfMsgBox, Yes
			Run, https://github.com/rfoxxxyshit/aye-ahk-loader/releases/
	}
}


ConfigOpen()
{
	run, notepad.exe "C:\AYE\config.ini"
}
ShowAbout()
{
	Logging(1,"Building About GUI...")
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
	Gui, About:Show, w315 h155, %script% v%version% | About
    Gui, About:Add, Text, x112 y9 w100 h20 +Center, %script%
    Gui, About:Add, Text, x59 y29 w200 h30 +Center, %string_desc%
	Gui, About:Add, Link, x79 y69 w200 h20 +Center, %string_devs% <a href="http://m4x3r.me/">%string_dev1%</a> and <a href="http://rf0x3d.su/">%string_dev2%</a>
	Gui, About:Add, Text, x59 y89 w200 h20 +Center, %string_count% %cheatsCount%
	Gui, About:Add, Link, x50 y115 w100 h20 +Center, <a href="https://github.com/rfoxxxyshit/aye-ahk-loader">Github</a>
	Gui, About:Add, Link, x210 y115 w100 h20 +Center, <a href="https://qiwi.me/rfoxxxyshit">Donate :)</a>
	Logging(1,"done.")
	return	
}
RunAsAdmin()
{
	if (A_IsAdmin = false) 
	{ 
		Logging(1,"Restarting as admin...")
   		Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel 
	}
}
