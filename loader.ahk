#SingleInstance force
#NoTrayIcon
#include Lib\functions.ahk
FileDelete, %A_TEMP%\cheats.ini
FileDelete, C:\AYE\*.dll


global script = "AYE Loader"
global version = "1.2.9-beta"

Logging(1,"Starting AYE Loader v" version "...")




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



IniRead, language, C:\AYE\config.ini, settings, language
if (language = "ERROR")
{
	MsgBox, 68, , Если вы хотите использовать Русский язык, нажмите Да.`nIf you want to use English, click No.`n`nДанное сообщение появляется только при первом запуске.`nThis message appears only on the first launch.
	IfMsgBox, Yes
		IniWrite, ru, C:\AYE\config.ini, settings, language
	IfMsgBox, No
		IniWrite, en, C:\AYE\config.ini, settings, language
}


Logging(1,"Getting vars...")
IniRead, cheatlist, %A_TEMP%\cheats.ini, cheatlist, cheatlist
IniRead, custominject, C:\AYE\config.ini, settings, custominject
IniRead, language, C:\AYE\config.ini, settings, language
; StringLower, custominject, custominject

Logging(1,"Building GUI...")


Gui, Font, s9
Gui, Show, w315 h195, %script% v%version%
Gui, Add, Text, x112 y9 w100 h20 +Center, %script%
Gui, Add, Progress, x22 y39 w270 h20 -smooth +Center vPbar


if (custominject = "true")
{
	Logging(1,"Custom injection was enabled!")
	Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%|Load DLL
} else {
	Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%
}
if (language = "en")
{
	Gui, Add, Button, x15 y129 w100 h20 +Center gLoad, Load
	Gui, Add, Button, x200 y129 w100 h20 +Center gKill, Kill CS:GO
	Menu, AppMenu, Add, &Config, ConfigOpen
	Menu, AppMenu, Add, &About, ShowAbout
	Gui, Menu, AppMenu
} 
if (language = "ru")
{
	Gui, Add, Button, x15 y129 w100 h20 +Center gLoad, Заинжектить
	Gui, Add, Button, x200 y129 w100 h20 +Center gKill, Закрыть CS:GO
	Menu, AppMenu, Add, &Настройки, ConfigOpen
	Menu, AppMenu, Add, &Инфо, ShowAbout
	Gui, Menu, AppMenu
}


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
	if (language = "ru")
	{
		MsgBox, 4, %script%, Процесс csgo.exe не найден. Запустить?
	}
	if (language = "en")
	{
		MsgBox, 4, %script%, No csgo.exe process found. Run it?
	}
	IfMsgBox, Yes
		try {
			Logging(1,"Starting csgo...")
			Run, steam://run/730
			Return
		} catch e {
			if (language = "ru")
			{
				MsgBox, 0, %script%, Стим установи долбаебище.
			}
			if (language = "en")
			{
				MsgBox, 0, %script%, Install steam, retard.
			}
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
	Inject_Dll(PID,TO_LOAD)
	GuiControl,, Pbar, 100
	if (language = "en")
	{
		MsgBox, Successful injection!
	}
	if (language = "ru")
	{
		MsgBox, Инжект прошел успешно!
	}
	Logging(1,"Injected " DLL)
	GuiControl,, Pbar, 0
	Return
}


if (PID > 0) and (Cheat = "Load DLL")
{	
	if (language = "ru")
	{
		MsgBox, 4, %script%, Мы не будем тебе помогать если у тебя нахуй система полетит винда нахуй слетит это не наша вина.`nПонял?
	}
	if (language = "en")
	{
		MsgBox, 4, %script%, We're not gonna help you if your fucking system is gonna blow the fucking wine off it's not our fault. `nGot it?
	}	
	IfMsgBox, Yes
	{
		Logging(1,"Initialized custom injection")
		FileSelectFile, DLL, 3, , %script% | Select DLL, DLL (*.dll)
		if (DLL = "")
		{
			Logging(1,"DLL not selected")
			if (language = "ru")
			{
				MsgBox, 0, %script%, Ты не выбрал DLL.
			}
			if (language = "en")
			{
				MsgBox, 0, %script%, You didn't choose the DLL.
			}
		}
		else {
			Logging(1,"Injecting custom dll...")
			GuiControl,, Pbar, 0
			INJECT := Inject_Dll(PID,DLL)
			if (!INJECT)
			{
				Logging(2,"Injection failed. DLL: " DLL)
				Return
			}
			GuiControl,, Pbar, 100
			if (language = "en")
			{
				MsgBox, Successful injection!
			}
			if (language = "ru")
			{
				MsgBox, Инжект прошел успешно!
			}
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
	if (language = "ru")
	{
		MsgBox, 4, AYE Loader, Кнопка Закрыть CS:GO предназначена для закрытия процесса csgo.exe`, если после игры с fatality.win ничего не инжектится.`nУбить CS:GO?
	}
	if (language = "en")
	{
		MsgBox, 4, AYE Loader, The Kill CS:GO button is designed to close the csgo.exe process`n if nothing is injected after playing with fatality.win. `nKill CS:GO?
	}
	IfMsgBox, Yes
	{
		KillCsgo()
		if (language = "en")
		{
			MsgBox, 0, AYE Loader, CS:GO killed!
		}
		if (language = "ru")
		{
			MsgBox, 0, AYE Loader, CS:GO закрыта!
		}
		Logging(1,"Killed csgo")
	}
	Return
}
