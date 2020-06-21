#SingleInstance force
#NoTrayIcon
FileDelete, %A_TEMP%\cheats.ini
FileDelete, C:\AYE\*.dll

global script = "AYE Loader"
global version = "1.2.8-beta"
global authors = "m4x3r1337 and rf0x1d"
Logging(1,"Starting AYE Loader v" version "...")

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
	Gui, About:Show, w315 h205, %script% v%version% | About
	Gui, About:Add, Text, x112 y9 w100 h20 +Center, %script%
	Gui, About:Add, Text, x59 y29 w200 h30 +Center, АУЕ лоадер для АУЕ пацанов с открытым исходным кодом.
	Gui, About:Add, Text, x59 y69 w200 h20 +Center, Разработчики: %authors%
	Gui, About:Add, Text, x59 y89 w200 h20 +Center, Текущее кол-во читов: %cheatsCount%
	Gui, About:Add, Button, x50 y160 w100 h20 +Center gSource, Source code
	Gui, About:Add, Button, x180 y160 w100 h20 +Center gDonate, Donate
	Logging(1,"done.")
	return
}
OpenGitHubPage()
{
	Run https://github.com/rfoxxxyshit/aye-ahk-loader
	return
}
OpenDonatePage()
{
	Run https://qiwi.com/n/m4x3r1337
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

RunAsAdmin()
Logging(1, "Creating folders and downloading files...")
IfNotExist, C:\AYE
{	
	Logging(1, "Creating folder...")
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\config.ini
{	
	Logging(1, "Creating config file...")
	IniWrite, false, C:\AYE\config.ini, settings, custominject
}
IfNotExist, %A_TEMP%\cheats.ini
{	
	Logging(1, "Getting cheat list...")
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/cheats.ini, %A_TEMP%\cheats.ini
	GuiControl,, Pbar, 100
}
Logging(1,"Getting vars...")
IniRead, cheatlist, %A_TEMP%\cheats.ini, cheatlist, cheatlist
IniRead, custominject, C:\AYE\config.ini, settings, custominject
StringLower, custominject, custominject
Logging(1,"Building GUI...")
Menu, AppMenu, Add, &Config, ConfigOpen
Menu, AppMenu, Add, &About, ShowAbout
Gui, Menu, AppMenu
Gui, Font, s9
Gui, Show, w315 h165, %script% v%version%
Gui, Add, Text, x112 y9 w100 h20 +Center, %script%
Gui, Add, Progress, x22 y39 w270 h20 -smooth +Center vPbar

IniRead, dll, 228.ini, cheats, Cheat

if (custominject = "true")
{
	Logging(1,"Custom injection was enabled!")
	Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%|Load DLL
} else {
	Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%
}
Gui, Add, Button, x15 y129 w100 h20 +Center gLoad, Load
Gui, Add, Button, x200 y129 w100 h20 +Center gKill, Kill CS:GO

GuiControl,, Pbar, 0
Logging(1,"done.")
return
GuiClose:
ExitApp
Load:
Gui, Submit, NoHide

Process, Wait, csgo.exe, 1
PID = %ErrorLevel%
if (PID == 0)
{
	Logging(2,"csgo process not found. promting to start.")
	MsgBox, 4, %script%, Процесс csgo.exe не найден. Запустить?
	IfMsgBox, Yes
		try {
			Logging(1,"Starting csgo...")
			Run, steam://run/730
			Return
		} catch e {
			MsgBox, 0, %script%, Стим установи долбаебище
			Logging(2,"steam not found")
			return
		}
	IfMsgBox, No
		Return
}

if (Cheat != "Load DLL") and (PID > 0)
{
	Logging(1,"Initialized dll injection")
	IniRead, dll, %A_TEMP%\cheats.ini, cheats, %Cheat%
	FileDelete, C:\AYE\%dll%
	Sleep 1500
	IfNotExist, C:\AYE\%dll%
	{
		Logging(1,"Downloading " DLL "...")
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/%dll%, C:\AYE\%dll%
		Sleep 2500
		GuiControl,, Pbar, 100
	}
	Logging(1,"Injecting " DLL "...")
	TO_LOAD = C:\AYE\%dll%
	GuiControl,, Pbar, 0
	getVAC(PID,TO_LOAD)
	GuiControl,, Pbar, 100
	MsgBox, Successful injection!
	Logging(1,"Injected " DLL)
	GuiControl,, Pbar, 0
	Return
}


if (PID > 0) and (Cheat = "Load DLL")
{
	MsgBox, 4, %script%, Мы не будем тебе помогать если у тебя нахуй система полетит винда нахуй слетит это не наша вина.`nПонял?
	IfMsgBox, Yes
	{
		Logging(1,"Initialized custom injection")
		FileSelectFile, DLL, 3, , %script% | Select DLL, DLL (*.dll)
		if (DLL = "")
		{
			Logging(1,"DLL not selected")
			MsgBox, 0, %script%, Ты не выбрал DLL.
		}
		else {
			Logging(1,"Injecting custom dll...")
			GuiControl,, Pbar, 0
			INJECT := getVAC(PID,DLL)
			if (!INJECT)
			{
				Logging(2,"Injection failed. DLL: " DLL)
				Return
			}
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected custom dll")
			ExitApp
		}
	}
	IfMsgBox, No
		Return
	Return
}

Kill:
{
	MsgBox, 4, AYE Loader, Кнопка Kill CS:GO предназначена для закрытия процесса csgo.exe`, если после игры с fatality.win ничего не инжектится.`nУбить CS:GO?
	IfMsgBox, Yes
	{
		KillCsgo()
		MsgBox, 0, AYE Loader, csgo killed
		Logging(1,"Killed csgo")
	}
	Return
}
Source:
OpenGitHubPage()
Donate:
OpenDonatePage()