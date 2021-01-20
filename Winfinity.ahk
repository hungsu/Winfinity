#Persistent
Gui +LastFound
hWnd := WinExist()

DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )
Return

ShellMessage( wParam,lParam ) {
  Local k
  If ( wParam = 1 ) ;  HSHELL_WINDOWCREATED := 1
  {
    NewID := lParam
    appsOpenToMove.push(%NewID%)
    SetTimer, HandleNewWindow, -1
  }
}

HandleNewWindow:
  AvailableWidth := 2560
  ; AvailableWidth := A_ScreenWidth
  ; This height seems to sometimes be wrong? Probably Windows 10's fault.
  ScreenHeightMinusTaskbar := 1400
  WinGet appsOpen, List
appsOpenToMove := []
Loop %appsOpen%
{
  id := appsOpen%A_Index%
  WinGetClass wc, ahk_id %id%
  WinGetTitle wt, ahk_id %id%
  if wc in Chrome_WidgetWin_1,MozillaWindowClass,CabinetWClass,Qt5152QWindowOwnDCIcon,Viber
    appsOpenToMove.push(id)
}
  Index := appsOpenToMove.Length()
  Index := 1
  Loop 3
  {
    appId := appsOpenToMove[Index]
    WinGetPos, , , WinWidth, , ahk_id %appId%
    WinXPosition := AvailableWidth - WinWidth
    WinMove ahk_id %appId%,, %WinXPosition%, 0, , ScreenHeightMinusTaskbar
    AvailableWidth := WinXPosition
    Index := Index + 1
  }
Return

; When Win+Backspace pressed
#BackSpace::
; Kill current window
  WinKill A
; Move other windows right
  SetTimer, HandleNewWindow, -1
return

; When Win+N pressed
#n::
; Maximise height of current window
WinMove A,, , 0, , 1400 ; Curiously this height of 1400 seems to sometimes be wrong? Probably Windows 10's fault.
return
