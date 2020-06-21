Inject_CleanUp(pMsg, pHandle, pLibrary)
{
    If pMsg
    MsgBox, 0, :(, % "Error Code: " . DllCall("GetLastError") . "`n" . pMsg
    If pLibrary
    DllCall("VirtualFreeEx", "UInt", pHandle, "UInt", pLibrary, "UInt", 0, "UInt", 0x8000)
    If pHandle
    DllCall("CloseHandle", "UInt", pHandle)
    Return False
}
getVAC(pID, dllPath)
{
    PROCESS_ALL_ACCESS := 0x1FFFFF,
    MEM_COMMIT := 0x1000,
    MEM_RESERVE := 0x2000,
    MEM_PHYSICAL := 0x004,
    WAIT_FAILED := 0xFFFFFFFF
    Size := VarSetCapacity(dllFile, StrLen(dllPath)+1, NULL)
    StrPut(dllPath, &dllFile)
    If (!pHandle := DllCall("OpenProcess", "UInt", PROCESS_ALL_ACCESS, "Char", False, "UInt", pID))
    {
        Return Inject_CleanUp("Ну блять пиздос четырка не заводится`nInvalid PID. Напиши это разрабу", NULL, NULL)
        Logging(2,"Invalid PID")
    }
    If (!pLibrary := DllCall("VirtualAllocEx", "Ptr", pHandle, "Ptr", NULL, "Ptr", Size, "Ptr", MEM_RESERVE | MEM_COMMIT, "Ptr", MEM_PHYSICAL))
    {
        Return Inject_CleanUp("Couldn't allocate memory!", pHandle, NULL)
        Logging(2,"Couldn't allocate memory!")
    }
    If (!DllCall("WriteProcessMemory", "Ptr", pHandle, "Ptr", pLibrary, "Ptr", &dllFile, "Ptr", Size, "Ptr", NULL))
    {
        Return Inject_CleanUp("Взлом жопы не удался`nПопробуй запустить лоадер от имени админа", pHandle, pLibrary)
        Logging(2,"Not enough rights")
    }
    If (!pModule := DllCall("GetModuleHandle", "Str", "kernel32.dll"))
    {
        Return Inject_CleanUp("Пошел нахуй!", pHandle, pLibrary)
        Logging(2,"Unknown error")
    }
    If (!pFunc := DllCall("GetProcAddress", "Ptr", pModule, "AStr", A_PtrSize = 4 ? "LoadLibraryA" : "LoadLibraryW"))
    {
        Return Inject_CleanUp("Обнови винду!", pHandle, pLibrary)
        Logging(2,"Windows build issue MAYBE????")
    }
    If (!hThread := DllCall("CreateRemoteThread", "Ptr", pHandle, "UIntP", NULL, "UInt", NULL, "Ptr", pFunc, "Ptr", pLibrary, "UInt", NULL, "UIntP", NULL))
    {
        Return Inject_CleanUp("Couldn't create thread in PID: " pID, pHandle, pLibrary)
        Logging(2,"Couldn't create thread in PID")
    }
    DllCall("WaitForSingleObject", "Ptr", hThread, "UInt", WAIT_FAILED)
    If !DllCall("GetExitCodeThread", "Ptr", hThread, "UIntP", lpExitCode)
    Inject_CleanUp("Couldn't create thread in PID: " pID, pHandle, pLibrary)
    DllCall("CloseHandle", "UInt", hThread)
}
