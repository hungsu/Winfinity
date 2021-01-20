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
    WinGetClass wc, ahk_id %NewID%
    if wc in Chrome_WidgetWin_1,MozillaWindowClass,CabinetWClass,Qt5152QWindowOwnDCIcon,Viber
    {
      appsOpenToMove.push(%NewID%)
      SetTimer, ArrangeWindows, -1
    }
  }
  If ( wParam = 2 ) ;  HSHELL_WINDOWDESTROYED := 2
  {
    SetTimer, ArrangeWindows, -1
  }
}

ArrangeWindows:
  SysGet, MonitorWorkArea, MonitorWorkArea
  AvailableWidth := MonitorWorkAreaRight
  ; This height seems to sometimes be wrong? Probably Windows 10's fault.
  ScreenHeightMinusTaskbar := MonitorWorkAreaBottom
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

HandleCloseWindow:
  TrayTip, Window closed, %lParam%
Return

; When Win+Backspace pressed
#BackSpace::
; Kill current window
  WinKill A
return

; When Win+Enter pressed
#Enter::
  SetTimer, ArrangeWindows, -1
return

; When Win+N pressed
#n::
; Maximise height of current window
WinMove A,, , 0, , 1400 ; Curiously this height of 1400 seems to sometimes be wrong? Probably Windows 10's fault.
return
