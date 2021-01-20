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
       SetTimer, MsgBox, -1
     }
     ; When new window created: move it to top right corner, consume full height, move other windows to left
}

MsgBox:
 ; This height seems to sometimes be wrong? Probably Windows 10's fault.
 ScreenHeightMinusTaskbar := 1400
 WinGetTitle, Title, ahk_id %NewID%
 WinGetPos, , , WinWidth, , %Title%
 ; Width of screen minus width of window
 WinXPosition := A_ScreenWidth - WinWidth
 WinMove %Title%,, %WinXPosition%, 0, , ScreenHeightMinusTaskbar
 ;How to get list of other windows?
Return

; When Win+Backspace pressed
#BackSpace::
; Kill current window
WinKill A
; Move other windows right
return

; When Win+N pressed
#n::
; Maximise height of current window
WinMove A,, , 0, , 1400 ; Curiously this height of 1400 seems to sometimes be wrong? Probably Windows 10's fault.
return
