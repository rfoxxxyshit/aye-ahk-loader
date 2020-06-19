#SingleInstance force
#NoTrayIcon
FileDelete, %A_TEMP%\cheats.ini
FileDelete, C:\AYE\*.dll

global script = "AYE Loader"
global version = "1.2.7"
global authors = "m4x3r1337 & rf0x1d"

ConfigOpen()
{
	run, notepad.exe "C:\AYE\config.ini"
}
KillCsgo()
{
	Loop 2
	{
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
   		Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel 
	}
}

RunAsAdmin()

IfNotExist, C:\AYE
{
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\config.ini
{
	IniWrite, true, C:\AYE\config.ini, settings, autoupdate
	IniWrite, false, C:\AYE\config.ini, settings, custominject
}
IfNotExist, %A_TEMP%\cheats.ini
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/cheats.ini, %A_TEMP%\cheats.ini
	GuiControl,, Pbar, 100
}
IniRead, autoupdate, C:\AYE\config.ini, settings, autoupdate
IniRead, cheatlist, %A_TEMP%\cheats.ini, cheatlist, cheatlist
IniRead, custominject, C:\AYE\config.ini, settings, custominject
StringLower, autoupdate, autoupdate
StringLower, custominject, custominject
if (autoupdate = "true")
{
	FileDelete, C:\AYE\*.dll ; бюджетный автоапдейт
}

Menu, ConfigMenu, Add, &Config, ConfigOpen
Gui, Menu, ConfigMenu
Gui, Font, s9
Gui, Show, w315 h165, %script% v%version%
Gui, Add, Text, x112 y9 w100 h20 +Center, %script%
Gui, Add, Progress, x22 y39 w270 h20 -smooth +Center vPbar

IniRead, dll, 228.ini, cheats, Cheat

if (custominject = "true")
{
	Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%|Load DLL
} else {
	Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%
}
Gui, Add, Button, x15 y129 w100 h20 +Center gLoad, Load
Gui, Add, Button, x200 y129 w100 h20 +Center gKill, Kill CS:GO

GuiControl,, Pbar, 0
return
GuiClose:
ExitApp
Load:
Gui, Submit, NoHide

Process, Wait, csgo.exe, 1
PID = %ErrorLevel%
if (PID == 0)
{
	MsgBox, 4, %script%, Процесс csgo.exe не найден. Запустить?
	IfMsgBox, Yes
		try {
			Run, steam://run/730
			Return
		} catch e {
			MsgBox, 0, %script%, Стим установи долбаебище
			Logging(2,"not found steam")
			return
		}
	IfMsgBox, No
		Return
}

if (Cheat != "Load DLL") and (PID > 0)
{
	IniRead, dll, %A_TEMP%\cheats.ini, cheats, %Cheat%
	FileDelete, C:\AYE\%dll%
	Sleep 1500
	IfNotExist, C:\AYE\%dll%
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/%dll%, C:\AYE\%dll%
		Sleep 2500
		GuiControl,, Pbar, 100
	}
	TO_LOAD = C:\AYE\%dll%
	GuiControl,, Pbar, 0
	Inject_Dll(PID,TO_LOAD)
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
		FileSelectFile, DLL, 3, , %script% | Select DLL, DLL (*.dll)
		if (DLL = "")
			MsgBox, 0, %script%, Ты не выбрал DLL.
		else {
			GuiControl,, Pbar, 0
			INJECT := Inject_Dll(PID,DLL)
			if (!INJECT)
				Return
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected our dll")
			ExitApp
		}
	}
	IfMsgBox, No
		Return
	Return
}

Kill:
{
	MsgBox, Кнопка kill csgo предназначена для закрытия процесса csgo.exe, если после игры с fatality.win ничего не инжектится.
	KillCsgo()
	MsgBox, csgo killed
	Logging(1,"Kill csgo")
	Return
}