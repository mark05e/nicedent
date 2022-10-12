; ===========================================================
; nicedent - NICE inContact Studio - Snippet Editor Hotkeys
; https://github.com/mark05e/nicedent
; ===========================================================

#NoEnv ;Recommended for performance.
#SingleInstance Force ;Make Single instance application.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.
SetTitleMatchMode,2
SendMode Input ;Makes Send synonymous with SendInput. Recommended for new scripts due to its superior speed and reliability.

#Include .\lib\obj2str.ahk  ;https://gist.github.com/errorseven/3b1e89e4d2f4d50b782f54954b2a97ca

Global AppVersion := "0.6"
Global AppName := "Nicedent"
Global AppName := AppName . " " . AppVersion

LogEnable := false
; sendInputMethodEnable := true

; Color Variables used in findAndClickPixel
Global settings := []
settings["color_Uncomment"] := "0xbf0b0b"
settings["color_Comment"] := "0x0b79bf"
settings["color_CheckSyntax"] := "0x5b9353"
settings["color_StartExecution"] := "0x4ab018"
settings["color_ToolsIcon"] := "0xb5363d" ; Trace Output Window
settings["color_WatchIcon"] := "0x93c1fe" ; Trace Output Window
settings["PixelSearch_Variation"] := 4 ;
settings["pixels_traceWindow_xFromRight"] := 20 ;
settings["pixels_traceWindow_yFromTop"] := 40 ;
settings["debug_showRedBox"] := false ;
settings["debug_showCommandTriggeredAsToast"] := true ;
settings["debug_showRedBox_timeInMs"] := 1000 ;

WriteLog("------------APP START------------")

; INI File
Global OutNameNoExt
SplitPath, A_ScriptName, , , , OutNameNoExt
; ReadIniFile()

; Tray Menu
menu_item_2 := "About this app"
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, %AppName%, showAboutWindow
Menu, Tray, Disable, %AppName%
Menu, Tray, Tip, %AppName%
Menu, Tray, Add, %menu_item_2%, showAboutWindow
Menu, Tray, default, %menu_item_2%
Menu, Tray, Click, 1
I_Icon := "like_64px.ico" ; https://www.flaticon.com/free-icons/like
IfExist, %I_Icon%
  Menu, Tray, Icon, %I_Icon%

; Table content generated from https://ozh.github.io/ascii-tables/

HelpContentSnippet =
(
+======================================+==================+
|               Function               |      Hotkey      |
+======================================+==================+
| Comment                              | ctrl + /         |
+ .                                    +------------------+
| .                                    | ctrl + k         |
+--------------------------------------+------------------+
| Uncomment                            | ctrl + shift + / |
+ .                                    +------------------+
| .                                    | ctrl + shift + k |
+--------------------------------------+------------------+
| Check Syntax                         | ctrl + enter     |
+--------------------------------------+------------------+
| Start Execution                      | f5               |
+--------------------------------------+------------------+
| Activate Tree View                   | f6               |
+--------------------------------------+------------------+
| Activate Tree View + Start Execution | ctrl + f6        |
+--------------------------------------+------------------+

)

HelpContentTraceOutput = 
(
+=======================+==================+
|       Function        |      Hotkey      |
+=======================+==================+
| Save Trace As         | ctrl + s         |
+-----------------------+------------------+
| Save Watch List       | ctrl + shift + s |
+-----------------------+------------------+
| Show Global Variables | ctrl + shift + 1 |
+-----------------------+------------------+
| Show System Variables | ctrl + shift + 2 |
+-----------------------+------------------+
| Show Private Members  | ctrl + shift + 3 |
+-----------------------+------------------+
| Add to watch list     | f1               |
+-----------------------+------------------+

)

;===========================================
; Hotkeys
;===========================================
; #if isStudioCanvasActive()
; ^w::
  ; ; ClassNN:	WindowsForms10.Window.8.app.0.a0f91b_r8_ad16
  ; SetControlDelay -1
  ; ControlClick, WindowsForms10.Window.8.app.0.a0f91b_r8_ad16
  ; TrayTip STUDIO WINDOW, Click CLOSE
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
  ; return

#if isSnippetWindowActive()

; ctrl + /
; ctrl + k
^/::
^k::
  findAndClickPixel("comment")
  ; TrayTip SNIPPET WINDOW, Click Comment
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
  return

; ctrl + shift + /
; ctrl + shift + k  
^+/::
^+k::
  findAndClickPixel("uncomment")
  ; TrayTip SNIPPET WINDOW, Click Uncomment
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
  return
  
^s::
  ; ClassNN:	WindowsForms10.BUTTON.app.0.a0f91b_r8_ad12
  ; Text:	OK
  SetControlDelay -1
  ControlClick, WindowsForms10.BUTTON.app.0.a0f91b_r8_ad12
  Send {Enter}
  return

; ctrl + enter
^enter::
  findAndClickPixel("checksyntax")
  ; TrayTip SNIPPET WINDOW, Check Syntax
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
  return
  
F5::
  findAndClickPixel("startexecution")
  ; TrayTip SNIPPET WINDOW, Start Execution
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
  return
  
F6::
  activateControlVarTree()
  ; TrayTip SNIPPET WINDOW, Activate Contral Variable Tree
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
  return
  
^F6::
  activateControlVarTree()
  findAndClickPixel("startexecution")
  ; TrayTip SNIPPET WINDOW, Start Execution
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
  return
  
^(::
  tmp = %ClipboardAll% ; save clipboard
	CoverSelectedText("brakets")
  Sleep 2
	Clipboard = %tmp% ; restore old content of the clipboard
return

^{::
  ; formatting for code editor}
  tmp = %ClipboardAll% ; save clipboard
	CoverSelectedText("curlyBrakets")
  Sleep 2
	Clipboard = %tmp% ; restore old content of the clipboard
return

^'::
  tmp = %ClipboardAll% ; save clipboard
	CoverSelectedText("singleQuotes")
  Sleep 2
  Clipboard = %tmp% ; restore old content of the clipboard
return

^"::
  ; formatting for code editor"
  tmp = %ClipboardAll% ; save clipboard
	CoverSelectedText("doubleQuotes")
  Sleep 2
  Clipboard = %tmp% ; restore old content of the clipboard
return

^<::
  tmp = %ClipboardAll% ; save clipboard
	CoverSelectedText("angleBrakets")
  Sleep 2
	Clipboard = %tmp% ; restore old content of the clipboard
return

Capslock::
  showHelpWindow("snippet", HelpContentSnippet)
Return

#if isTraceWindowActive()

^s::
  findAndClickPixel("toolsicon")
  Send {Up}{Enter}
  ; TrayTip TRACE WINDOW, Save Trace
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
return
  
^+s::
  findAndClickPixel("toolsicon")
  Send {Up}{Up}{Enter}
  ; TrayTip TRACE WINDOW, Save watchlist
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
return

; Show Global Variables
^+1::
  findAndClickPixel("toolsicon")
  Send {Down}{Enter}
  ; TrayTip TRACE WINDOW, Show Global Variables
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
return

; Show System Variables
^+2::
  findAndClickPixel("toolsicon")
  Send {Down}{Down}{Enter}
  ; TrayTip TRACE WINDOW, Show System Variables
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
return

; Show Private Members
^+3::
  findAndClickPixel("toolsicon")
  Send {Down}{Down}{Down}{Enter}
  ; TrayTip TRACE WINDOW, Show Private Members
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
return

; Click Watch Icon
f1::
  findAndClickPixel("watchicon")
  ; TrayTip TRACE WINDOW, Watch Variable
  ; Sleep 3000   ; Let it display for 3 seconds.
  ; HideTrayTip()
return

Capslock::
  showHelpWindow("trace", HelpContentTraceOutput)
Return

^w::
  WinGetPos, windowX, windowY, windowW, windowH
  MouseGetPos, mouseX, mouseY
  ; settings["pixels_traceWindow_xFromRight"]
  ; settings["pixels_traceWindow_yFromTop"]
  LocationX := windowW - settings["pixels_traceWindow_xFromRight"]
  LocationY := settings["pixels_traceWindow_yFromTop"]
  Rect_Draw(LocationX, LocationY,5,5)
  MouseMove, LocationX, LocationY
  Click
  MouseMove, mouseX, mouseY
return

#IfWinActive ahk_class AutoHotkeyGUI
  Capslock::GUI,Destroy
return

#IfWinActive
^+\:: Reload

; ^+!1:: 
  ; MsgBox % settings["PixelSearch_Variation"]
  ; return

;===========================================

showAboutWindow(){
  msgContent := AppName . "`n`n"
  someBar := "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n"
  usageText = 
    (
; USAGE

; Inside Snippet Editor
    
;   Comment selection   -> ctrl + / OR ctrl + k
  
;   UnComment selection -> ctrl + shift + / OR ctrl + shift + k
  
;   Check Syntax        -> ctrl + enter
  
;   Start Execution     -> F5
  
;   Show Variable Tree  -> F6
  
;   Show Variable Tree & Start Execution -> ctrl + F6

; Inside Trace Output window

;   Save Trace As           ->  ctrl + s

;   Save Watch List         ->  ctrl + shift + s

;   Show Global Variables   ->  ctrl + shift + 1`

;   Show System Variables   ->  ctrl + shift + 2

;   Show Private Members    ->  ctrl + shift + 3

;   Add to watch list       ->  ctrl + q

    )
  contactInfo := "by mark05E"
  msgContent := msgContent . someBar . usageText . someBar . "`n`n" . contactInfo
  MsgBox, 64, %AppName% - About this app, %msgContent%, 15
}

activateControlVarTree(){
  ControlFocus, WindowsForms10.SysTabControl32.app.0.a0f91b_r8_ad13,
  Send {Right}
  Return
}

findAndClickPixel(item) {
  ; Requires color_ variables from  settings
  
  errMsg := "Sorry could not find what I was looking for. =(" 
  ;PixelSearch_Mode := Fast RGB
  
  switch item {
    case "comment":
      q3 := getSearchRange("q3v2")
      Rect_Draw(q3.x1, q3.y1,q3.w, q3.h)
      PixelSearch, OutputVarX, OutputVarY, q3.x1, q3.y1, q3.x2, q3.y2, settings["color_Comment"], settings["PixelSearch_Variation"], Fast RGB
      if (ErrorLevel=0 & isSnippetWindowActive())  {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      } else { 
        Msgbox % errMsg
      }
      Return
      
    case "uncomment":
      q3 := getSearchRange("q3v2")
      Rect_Draw(q3.x1, q3.y1,q3.w, q3.h)
      PixelSearch, OutputVarX, OutputVarY, q3.x1, q3.y1, q3.x2, q3.y2, settings["color_Uncomment"], settings["PixelSearch_Variation"], Fast RGB
      if (ErrorLevel=0 & isSnippetWindowActive()) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      } else { 
        Msgbox % errMsg
      }
      Return
      
    case "checksyntax":
      q3 := getSearchRange("q3v2")
      Rect_Draw(q3.x1, q3.y1,q3.w, q3.h)
      PixelSearch, OutputVarX, OutputVarY, q3.x1, q3.y1, q3.x2, q3.y2, settings["color_CheckSyntax"], settings["PixelSearch_Variation"], Fast RGB
      if (ErrorLevel=0 & isSnippetWindowActive()) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      } else { 
        Msgbox % errMsg
      }
      Return
      
    case "startexecution":
      q3 := getSearchRange("q2")
      Rect_Draw(q3.x1, q3.y1,q3.w, q3.h)
      PixelSearch, OutputVarX, OutputVarY, q3.x1, q3.y1, q3.x2, q3.y2, settings["color_StartExecution"], settings["PixelSearch_Variation"], Fast RGB
      if (ErrorLevel=0 & isSnippetWindowActive()) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      } else { 
        Msgbox % errMsg
      }
      Return
      
    case "toolsicon": ; Trace Output Window
      Rect_Draw(0, 0, 200, 100)
      PixelSearch, OutputVarX, OutputVarY, 0, 0, 200, 100, settings["color_ToolsIcon"], settings["PixelSearch_Variation"], Fast RGB
      if (ErrorLevel=0 & isTraceWindowActive()) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      } else { 
        Msgbox % errMsg
      }
      Return
      
    case "watchicon": ; Trace Output Window
      Rect_Draw(0, 0, 200, 100)
      PixelSearch, OutputVarX, OutputVarY, 0, 0, 200, 100, settings["color_WatchIcon"], settings["PixelSearch_Variation"], Fast RGB
      if (ErrorLevel=0 & isTraceWindowActive()) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      } else { 
        Msgbox % errMsg
      }
      Return
      
  }

}

getSearchRange(q) {
  size := getSnippetWindowSize()
  w_width  := size.w
  w_height  := size.h
  w_x := size.x // top left
  w_y := size.y // top left
  
  WinGetTitle, Title, A

  switch q {
    case "q2": 
      startX := w_width / 2
      startY := 0
      endX := w_width
      endY := w_height / 2

      result := {}
      result["x1"]   := startX
      result["y1"]   := startY
      result["x2"]   := endX
      result["y2"]   := endY
      result["w"]   := Abs(startX - endX)
      result["h"]   := Abs(startY - endY)
      result["q"]    := "q2"
      
      result["title"]:= Title
      WriteLog("getSearchRange: " . Obj2Str(result))
      return result
      
    case "q3":
      startX := 0
      startY := w_height / 2
      endX := w_width / 2
      endY := w_height

      result := {}
      result["x1"]   := startX
      result["y1"]   := startY
      result["x2"]   := endX
      result["y2"]   := endY
      result["w"]   := Abs(startX - endX)
      result["h"]   := Abs(startY - endY)
      result["q"]    := "q3"
      
      result["title"]:= Title
      WriteLog("getSearchRange: " . Obj2Str(result))
      return result
      
    case "q3v2":
      startX := 0
      startY := w_height * (3 / 4)
      endX := w_width / 2
      endY := w_height

      result := {}
      result["x1"]  := startX
      result["y1"]  := startY
      result["x2"]  := endX
      result["y2"]  := endY
      result["w"]   := Abs(startX - endX)
      result["h"]   := Abs(startY - endY)
      result["q"]   := "q3v2"
      
      result["title"]:= Title
      WriteLog("getSearchRange: " . Obj2Str(result))
      return result
      
    default:
      return 0
  }
}

isStudioCanvasActive() {
  if WinActive("- NICE inContact Studio Summer 22") {
    return 1
  }
}

isSnippetWindowActive() {
  if WinActive("Snippet") or WinActive("- Snippet Properties") {
    return 1
  }
}

isTraceWindowActive() {
  if WinActive("Trace Output") {
    return 1
  }
}

getSnippetWindowSize() {
  WinGetActiveStats, Title, Width, Height, X, Y
  ; MsgBox, The active window "%Title%" is %Width% wide`, %Height% tall`, and positioned at %X%`,%Y%.
  result := Object("w",Width, "h",Height, "x",X, "y",y, "Title",Title)
  WriteLog("getSnippetWindowSize: " . Obj2Str(result))
  return result
}

WriteLog(text) {
  if (LogEnable) {
    FileAppend, % A_Now ": " text "`n", %OutNameNoExt%_log.txt ; can provide a full path to write to another directory
  }
}

CoverSelectedText(coverType) {

  switch coverType {
    case "brakets":
      setLeft := "("
      setRight := ")"
    case "curlyBrakets":
      setLeft := "{"
      setRight := "}"  
    case "angleBrakets":
      setLeft := "<"
      setRight := ">"
    case "singleQuotes":
      setLeft := "'"
      setRight := "'"
    case "doubleQuotes":
      setLeft := """"
      setRight := """"
    default :
      setLeft := ""
      setRight := ""
  }
  
	Clipboard =  ; clear clipboard
	sleep 50
	Send ^c ; simulate Ctrl+C (=selection in clipboard)
	ClipWait, 2
  ClipboardCopy := Clipboard
	EL := ErrorLevel ; Zero if clipboard not empty, else one
  
  ;The section below needs some fixing when there is no selection being made.
  
	if (EL = 0) {
		ClipboardCopy := "" . ClipboardCopy . ""
    ; ClipboardCopy := StrReplace(ClipboardCopy, a_space, "`n")
    IfInString, ClipboardCopy, "`r"
      MsgBox % "x" . ClipboardCopy . "x"
		ClipboardCopy := setLeft . ClipboardCopy . setRight ; save the content of the clipboard
	}
	else {
    ClipboardCopy := setLeft . setRight
  }
  
  if (sendInputMethodEnable = true) {
    SendInput %ClipboardCopy%
  } else {
    Clipboard := ClipboardCopy
    ClipWait, 2
    Send ^v  ; ctrl + v
  }
  ; return ClipboardCopy
}

showHelpWindow(selection,  helpContent) {

; Get position of active window
WinGetPos, _xActive, _yActive,,, A
_xActive += 15
_yActive += 20

  switch selection {
    case "trace":
      MessageTitle := "Trace Output Hotkeys"
      MessageContent :=  helpContent
    case "snippet":
      ; default:
      MessageTitle := "Snippet Hotkeys"
      MessageContent :=  helpContent
  }
  
  SetCapslockState, Off

  ; Overlay Design from https://gist.github.com/ColonelBuendia/7f85bbaadef592a1b79a551a1794627b
  
  ; Title
  Gui, Add, Text,YM,
  Gui, Font, S20 Cyellow Bold
  Gui, Add, Text,YM, %MessageTitle%

  ; Content
  Gui, Font, S10 Cyellow, Courier New
  Loop, parse, MessageContent, `n, `r
  {
    Gui, Add, Text,, %A_LoopField%
  }
  
  ; Window Style
  Gui, -Caption
  Gui, Color, 884488
  Gui, Show, x%_xActive% y%_yActive%, Nicedent Help
  WinGet, active_id, ID, Nicedent Help
  WinSet, AlwaysOnTop, On, ahk_id %active_id%
  WinSet, Transparent, 190, ahk_id %active_id% 
  WinSet, ExStyle, +0x20400,ahk_id %active_id%

}

WriteIniFile(){
  Global settings
  IniFile = .\%OutNameNoExt%_settings.ini
  For _key, _val in settings {
    WriteLog("WriteIniFile - settings:" _key " = " _val)
    IniWrite, %_val%, %IniFile%, Settings, %_key%
  }
}

ReadIniFile(){
  IniFile = .\%OutNameNoExt%_settings.ini
  if FileExist(IniFile) {
    IniRead, SettingsDataFromFile, %IniFile%, Settings
    Loop, Parse, SettingsDataFromFile , `n
    {
      valArr := StrSplit(A_LoopField,"=")
      valArr[1]
      if (valArr[2] == "true") {
          valArr[2] := true
      }
      if (valArr[2] == "false") {
          valArr[2] := false
      }
      WriteLog("ReadIniFile - settings:" valArr[1] " = " valArr[2])
      settings[valArr[1]] := valArr[2]
    }
  } else {
    WriteLog("ReadIniFile - did not find " . IniFile . ". Triggering WriteIniFile.")
    WriteIniFile()
  }
}

; https://www.autohotkey.com/boards/viewtopic.php?t=25520
Rect_Draw(x, y, w, h)
{
  if (settings["debug_showRedBox"] != true) {
    return
  }
  border_color := FF0000
  border_thickness :=  5

  iw := w + border_thickness
  ih := h + border_thickness
  w  := w + ( border_thickness * 2 )
  h  := h + ( border_thickness * 2 )
  x  := x - border_thickness
  y  := y - border_thickness
  Gui, TheBoxThingy:+Lastfound +AlwaysOnTop +Toolwindow
  Gui, TheBoxThingy:Color, FF0000
  Gui, TheBoxThingy:-Caption

  ; outer rectangle
  o1a := 0
  o1b := 0
  o2a := w 
  o2b := 0 
  o3a := w 
  o3b := h 
  o4a := 0 
  o4b := h 
  o5a := 0
  o5b := 0

  ; inner rectangle
  i1a := border_thickness
  i1b := border_thickness
  i2a := iw
  i2b := border_thickness
  i3a := iw
  i3b := ih
  i4a := border_thickness
  i4b := ih
  i5a := border_thickness
  i5b := border_thickness

  ; Draw outer & inner window(s)
  WinSet, Region, %o1a%-%o1b% %o2a%-%o2b% %o3a%-%o3b% %o4a%-%o4b% %o5a%-%o5b%   %i1a%-%i1b% %i2a%-%i2b% %i3a%-%i3b% %i4a%-%i4b% %i5a%-%i5b%
  Gui, TheBoxThingy:Show, x%x% y%y% w%w% h%h%  NoActivate, Red Box
  
  Sleep settings["debug_showRedBox_timeInMs"]
  Rect_Destroy()

}

Rect_Destroy() {
  if (settings["debug_showRedBox"] != true) {
    return
  }
  Gui TheBoxThingy:destroy
}

; https://www.autohotkey.com/docs/commands/TrayTip.htm#Windows10
HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}
