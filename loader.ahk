#include includes\InjectDll.ahk
#SingleInstance force
Gui, Font, s9
Gui, Add, Button, x120 y80 w110 h30 +Center gLoad, Inject!
Gui, Add, Progress, x50 y50 w240 h20 -smooth +Center vPbar
Gui, Add, Text, x110 y10 w130 h20 +Center, OTC Loader by m4x3r1337
Gui, Show, w350 h150, OTC Loader
GuiControl,, Pbar, 0
return
GuiClose:
ExitApp
Load:
IfNotExist, C:\OTC
{
	FileCreateDir, C:\OTC
}
IfNotExist, C:\OTC\cheat.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/cheat.dll, C:\OTC\cheat.dll
	GuiControl,, Pbar, 50
}
IfNotExist, C:\OTC\addon.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/addon.dll, C:\OTC\addon.dll
	GuiControl,, Pbar, 100
}
Process, Wait, csgo.exe, 2
PID = %ErrorLevel%
if (PID == 0) {
	MsgBox, 4, OTC Loader, Процесс csgo.exe не найден. Запустить?
	IfMsgBox, Yes
		Run, steam://run/730
	IfMsgBox, No
		Return
}
if (PID > 0) {
	GuiControl,, Pbar, 0
	addon = C:\OTC\addon.dll
	Inject_Dll(PID, addon)
	GuiControl,, Pbar, 50
	Sleep 700
	cheat = C:\OTC\cheat.dll
	Inject_Dll(PID, cheat)
	GuiControl,, Pbar, 100
	MsgBox, Successful injection!
	ExitApp
}
