#include includes\logging.ahk
#include includes\InjectDll.ahk
#SingleInstance force
#NoTrayIcon
global script = "AYE Loader"
global version = "1.2.6"
global authors = "m4x3r1337 & rf0x1d"
IfNotExist, C:\AYE
{
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\config.ini
{
	IniWrite, true, C:\AYE\config.ini, settings, autoupdate
	IniWrite, false, C:\AYE\config.ini, settings, custominject
}
IniRead, autoupdate, C:\AYE\config.ini, settings, autoupdate
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
if (custominject = "true")
{
	Gui, Add, DropDownList, x112 y79 w100 vcheat Choose1, OTC|OTC+features.win|OTC+source.stealer|fatality.win|Fake skeet|BlazeHack 06.06|KillAura.host|weave.su|Load DLL
} else {
	Gui, Add, DropDownList, x112 y79 w100 vcheat Choose1, OTC|OTC+features.win|OTC+source.stealer|fatality.win|Fake skeet|BlazeHack 06.06|KillAura.host|weave.su
}
Gui, Add, Button, x15 y129 w100 h20 +Center gLoad, Load
Gui, Add, Button, x200 y129 w100 h20 +Center gKill, Kill CS:GO

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

GuiControl,, Pbar, 0
return
GuiClose:
ExitApp
Load:
Gui, Submit, NoHide
if (cheat != "Load DLL")
{
	IfNotExist, C:\AYE\otc.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/otc.dll, C:\AYE\otc.dll
		GuiControl,, Pbar, 15
	}
	IfNotExist, C:\AYE\ftc.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/ftc.dll, C:\AYE\ftc.dll
		GuiControl,, Pbar, 30
	}
	IfNotExist, C:\AYE\features.win.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/features.win.dll, C:\AYE\features.win.dll
		GuiControl,, Pbar, 45
	}
	IfNotExist, C:\AYE\skeet.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/skeet.dll, C:\AYE\skeet.dll
		GuiControl,, Pbar, 60
	}
	IfNotExist, C:\AYE\blazehack.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/blazehack.dll, C:\AYE\blazehack.dll
		GuiControl,, Pbar, 75
	}
	IfNotExist, C:\AYE\source.stealer.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/source.stealer.dll, C:\AYE\source.stealer.dll
		GuiControl,, Pbar, 90
	}
	IfNotExist, C:\AYE\killaura.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/killaura.dll, C:\AYE\killaura.dll
		GuiControl,, Pbar, 100
	}
	IfNotExist, C:\AYE\weave.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/weave.dll, C:\AYE\weave.dll
		GuiControl,, Pbar, 100
	}
}
Process, Wait, csgo.exe, 1
PID = %ErrorLevel%
if (PID == 0)
{
	MsgBox, 4, %script%, Процесс csgo.exe не найден. Запустить?
	IfMsgBox, Yes
		try {
			Run, steam://run/730
		} catch e {
			MsgBox, 0, %script%, Стим установи долбаебище
			Logging(2,"not found steam")
			return
		}
	IfMsgBox, No
		Return
}
if (PID > 0)
{
	Switch cheat
	{
		Case "OTC+features.win":
			TO_LOAD = C:\AYE\otc.dll
			ADDON = C:\AYE\features.win.dll
			GuiControl,, Pbar, 0
			Inject_Dll(PID,ADDON)
			GuiControl,, Pbar, 50
			Sleep 1250
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected OTC+features.win")
			ExitApp
		Case "OTC+source.stealer":
			TO_LOAD = C:\AYE\otc.dll
			ADDON = C:\AYE\source.stealer.dll
			GuiControl,, Pbar, 0
			Inject_Dll(PID,ADDON)
			GuiControl,, Pbar, 50
			Sleep 1250
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected OTC+source.stealer")
			ExitApp
		Case "fatality.win":
			TO_LOAD = C:\AYE\ftc.dll
			GuiControl,, Pbar, 0
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected fatality.win")
			ExitApp
		Case "OTC":
			TO_LOAD = C:\AYE\otc.dll
			GuiControl,, Pbar, 0
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected OTC")
			ExitApp
		Case "Fake skeet":
			TO_LOAD = C:\AYE\skeet.dll
			GuiControl,, Pbar, 0
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected Fake skeet")
			ExitApp
		Case "BlazeHack 06.06":			
			TO_LOAD = C:\AYE\blazehack.dll
			GuiControl,, Pbar, 0
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected BlazeHack 06.06")
			ExitApp
		Case "KillAura.host":
			TO_LOAD = C:\AYE\killaura.dll
			GuiControl,, Pbar, 0
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected KillAura.host")
			ExitApp
		Case "Load DLL":
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
		Case "weave.su":
			TO_LOAD = C:\AYE\weave.dll
			GuiControl,, Pbar, 0
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			Logging(1,"Injected weave.su")
			ExitApp
	}
} else
{
	MsgBox, 0, %script%, Ору нищ не пук
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