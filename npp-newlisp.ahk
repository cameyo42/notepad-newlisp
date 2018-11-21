;=====================================
; npp-newlisp.ahk
; Connect newLisp and editor (notepad++)
; AutoHotkey:     1.x
; Language:       English
; Platform:       Windows 7/10
; Author:         cameyo - 2018
; License:        MIT license
;=====================================
; Hotkeys:
; Win-F12 -> Start newLisp
; Left_Shift-Enter -> Evaluate current line
; Right_Shift-Enter -> Evaluate selected block
; Paste in REPL with Ctrl+v
; Insert Greek chars
; Swap [] with ()
; Control-Alt-q -> Insert text ";-> "


;=====================================
; How to set your editor:
; 1: run winspy utility (bundled with autohotkey)
; 2: run your editor
; 3: copy the ahk_class text value
; 4: set the global variable editor to "<ahk_class>"
; 5: That's all.
; EXAMPLES:
; (notepad++):
;global editor = "notepad++"
; (SciTE):
;global editor = "SciTEWindow"
; (Notepad)
;global editor = "Notepad";
; (PSPad)
;global editor = "TfPSPad.UnicodeClass"
; (Programmer's Notepad)
;global editor = "ATL:006AD5B8"
; (Sublime Text)
;global editor = "PX_WINDOW_CLASS"
;-------------------------------------
global editor = "notepad++"
;-------------------------------------
; To use (and view) the greek letters the editor must be set to UTF-8 encoding.
;=====================================

;=====================================
; Basic hotkeys symbol
;=====================================
; # Win key
; ! Alt key
; ^ Control key
; + Shift key

;=====================================
; General statements
;=====================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Allow reload script
#WinActivateForce ; activate window with forceful method

;=====================================
; Global variables
;=====================================
#EscapeChar \
global hasRunnewLisp = 0
global newLispPID = 0
global editorPID = 0

;---------------------------
OpennewLisp()
{
  if %hasRunnewLisp% = 0
  {
    Run newlisp.exe,,,newLispPID
    hasRunnewLisp = 1
    ReturnToEditor()
    return
  }
  Process, Exist, %newLispPID%
  if %ErrorLevel% = 0
  {
    Run newlisp.exe,,,newLispPID
    hasRunnewLisp = 1
    ReturnToEditor()
    return
  }
}
;---------------------------
ReOpennewLisp()
{
  WinClose, ahk_pid %newLispPID%
  OpennewLisp()
}
;---------------------------
SendTonewLisp()
{
  OpennewLisp()
  WinWait, ahk_pid %newLispPID%
  WinActivate, ahk_pid %newLispPID%
  WinWaitActive, ahk_pid %newLispPID%

  ;Paste via menu (must disable SendMode Input)
  ;Send {Alt Down}{Space}{Alt up}ep{Enter}

  ;Paste with send clipboard
  StringReplace clipboard2, clipboard, \r\n, \n, All
  SendInput {Raw}%clipboard2%\n
}
;---------------------------
ReturnToEditor()
{
  WinActivate, ahk_pid %editorPID%
  SendInput {End}
}
;---------------------------
PassLine()
{
  WinGetCLASS, currentClass, A
  If currentClass = %editor%
  {
    WinGet, editorPID, PID, A
    SendInput {Home}{Shift Down}{End}{Shift Up}{Ctrl Down}c{Ctrl Up}{End}
    SendTonewLisp()
    ReturnToEditor()
  }
}
;---------------------------
PassBlock()
{
  WinGetCLASS, currentClass, A
  If currentClass = %editor%
  {
    WinGet, editorPID, PID, A
    SendInput {Ctrl Down}c{Ctrl Up}
    SendTonewLisp()
    ReturnToEditor()
  }
}
;-------------------------------------------
; Eval current line (Left Shift - Enter)
LShift & Enter:: PassLine()
;-------------------------------------------

;-------------------------------------------
; Eval selected block (Right Shift - Enter)
RShift & Enter:: PassBlock()
;-------------------------------------------

;-------------------------------------------
; Run newLisp (Win-F12)
#$F12:: ReOpennewLisp()
;-------------------------------------------

;================================================
; REPL enhancements
; Work only on console window
#IfWinActive ahk_class ConsoleWindowClass

;=============================
; Scroll command window back and forward
; Ctrl+PageUp / PageDown
;=============================
^PgUp:: SendInput {WheelUp}

^PgDn:: SendInput {WheelDown}

;=============================
; Paste in REPL
; Ctrl-V
; Better version
;=============================
^V::
StringReplace clipboard2, clipboard, \r\n, \n, All
SendInput {Raw}%clipboard2%
return

;=============================
; Paste in REPL
; Ctrl-V
; Old version (must disable SendMode Input)
;=============================
;^V::
; English menu (Edit->Paste)
;Send !{Space}ep
;return

#IfWinActive
;================================================

;=============================
; Greek Letters (lowercase)
; Control-Win-<char>
; char 'j' can't be used (REPL)
; char 'q' is free...
; To use (and view) the greek letters the editor must be set to UTF-8 encoding.
; Note: a lot of these greek letters are protected in newLISP 10.7.1
;=============================
^#a:: SendInput {U+03B1} ; alpha
^#b:: SendInput {U+03B2} ; beta
^#g:: SendInput {U+03B3} ; gamma
^#d:: SendInput {U+03B4} ; delta
^#y:: SendInput {U+03B5} ; epsilon (y)
^#z:: SendInput {U+03B6} ; zeta
^#e:: SendInput {U+03B7} ; eta
^#h:: SendInput {U+03B8} ; theta (h)
^#i:: SendInput {U+03B9} ; iota
^#k:: SendInput {U+03BA} ; kappa
^#l:: SendInput {U+03BB} ; lambda
^#m:: SendInput {U+03BC} ; mu
^#n:: SendInput {U+03BD} ; nu
^#x:: SendInput {U+03BE} ; xi
^#o:: SendInput {U+03BF} ; omicron
^#p:: SendInput {U+03C0} ; pi
^#r:: SendInput {U+03C1} ; rho
^#s:: SendInput {U+03C3} ; sigma
^#t:: SendInput {U+03C4} ; tau
^#u:: SendInput {U+03C5} ; upsilon
^#f:: SendInput {U+03C6} ; phi (f)
^#c:: SendInput {U+03C7} ; chi
^#v:: SendInput {U+03C8} ; psi (v)
^#w:: SendInput {U+03C9} ; omega (w)

;-------------------------------------------
; Swap [] with ()
;-------------------------------------------
[::Send {( Down}
[ Up::Send {( Up}

]::Send {) Down}
] Up::Send {) Up}

+9::Send {[ Down}
+9 Up::Send {[ Up}

+0::Send {] Down}
+0 Up::Send {] Up}

;-------------------------------------------
; Control-Alt-q -> Insert text ";-> "
;-------------------------------------------
^!q:: Send {;}->{Space}

;-------------------------------------------
; Swap " with '
;-------------------------------------------
;$'::Send "
;+$'::Send '
