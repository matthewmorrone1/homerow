; words := StrSplit(str, "|")
; For key, value in words
;	MsgBox %key% %value%
; Loop % words.MaxIndex()
; 	word = %words%[A_Index]
; 	MsgBox %word%
; 	LV_Add("", A_Index, word)
; LV_ModifyCol()
#NoEnv

EnabledKeyList := "a`ns`nd`nf`ng`nh`nj`nk`nl"
DisabledKeyList := "q`nw`ne`nr`nt`ny`nu`ni`no`np`nz`nx`nc`nv`nb`nn`nm"
Loop, Parse, EnabledKeyList, `n
{
    Hotkey, ~%A_LoopField%, EnabledKey, UseErrorLevel
    Hotkey, ~+%A_LoopField%, EnabledShiftedKey, UseErrorLevel
}

Loop, Parse, DisabledKeyList, `n
{
    Hotkey, ~%A_LoopField%, DisabledKey, UseErrorLevel
    Hotkey, ~+%A_LoopField%, DisabledShiftedKey, UseErrorLevel
}

EnabledKey:
CurrentWord .= SubStr(A_ThisHotkey,2)
MsgBox %CurrentWord%
Gosub, Suggest
Return

EnabledShiftedKey:
Char := SubStr(A_ThisHotkey,3)
StringUpper, Char, Char
CurrentWord .= Char
Gosub, Suggest
Return

DisabledKey:
return

DisabledShiftedKey:
return


; #IfWinExist AutoComplete ahk_class AutoHotkeyGUI

; ~LButton::
; MouseGetPos,,, Temp1
; If (Temp1 != hWindow)
;     Gosub, ResetWord
; Return

; Up::
; Gui, Suggestions:Default
; GuiControlGet, Temp1,, Matched
; If Temp1 > 1 ;ensure value is in range
;     GuiControl, Choose, Matched, % Temp1 - 1
; Return

; Down::
; Gui, Suggestions:Default
; GuiControlGet, Temp1,, Matched
; GuiControl, Choose, Matched, % Temp1 + 1
; Return

; !1::
; !2::
; !3::
; !4::
; !5::
; !6::
; !7::
; !8::
; !9::
; !0::
; Gui, Suggestions:Default
; KeyWait, Alt
; Key := SubStr(A_ThisHotkey, 2, 1)
; GuiControl, Choose, Matched, % Key = 0 ? 10 : Key
; Gosub, SendWord
; Return

; #IfWinExist



; Gui, Suggestions:Default
; Gui, Font, s10, Courier New
; Gui, Add, ListBox, vMatched gSendWord AltSubmit
; Gui, -Caption +ToolWindow
; ; +AlwaysOnTop +LastFound
; hWindow := WinExist()
; Gui, Show
;, h165 Hide, AutoComplete


; Gui, Suggestions:Default
; 
; Gui, Add, ListBox, vWord gSendWord AltSubmit;, %DisplayList%
; Gui, -Caption +ToolWindow +AlwaysOnTop +LastFound
; hWindow := WinExist()


Suggest:

Gui, Suggestions:Default



; MsgBox,,, % MatchList.MaxIndex() " " DisplayList, 2

GuiControl,, Matched, %DisplayList%
GuiControl, Choose, Matched, 1

Gui, Show
return


GetWord:

GuiControlGet, Index, , Matched
Gui, Suggestions:Default
Gui, Destroy
NewWord := MatchList[Index]
SendWord(CurrentWord,NewWord)
Gosub, ResetWord

return






; If (MatchList.MaxIndex() = 0)
; {
; 	; Gui, Suggestions:Hide
; 	Gosub, ResetWord
;     Return
; }
; If (MatchList.MaxIndex() = 1)
; {
; 	; Gui, Suggestions:Hide
; 	SendWord(CurrentWord,MatchList[1])
;     Return
; }


#Warn All
#Warn LocalSameAsGlobal, Off

#MaxThreadsBuffer On
; Gui, Show
; return

; MyListBox:
; if A_GuiEvent = Normal
; {
;     LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
;     ; ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
;     ; WinActivate
;     ; Send %RowText%
;     ; Clipboard = %RowText%
;     ; Clipboard := RowText
;     ; Send {^v}
;     ; MsgBox %RowText%
;     ; Gui, Submit
; }
; return

; GuiClose:
; 	ExitApp
; return
CoordMode, Caret
OffsetX := 0 ;offset in caret position in X axis
OffsetY := 20 ;offset from caret position in Y axis
;obtain desktop size across all monitors
SysGet, ScreenWidth, 78
SysGet, ScreenHeight, 79
MaxWidth := 0
BoxHeight := 100 ;height of the suggestions box in pixels

ToGUI(str)
{
	global
	Gui, Destroy

	; local
	; gOutput
	; Gui, Font, s14 c885555
	Gui, Add, ListBox, x0 y0, %str%
	Gui, Add, Button, Default, OK
	; Gui, +Delimiter`n
	Gui, +ToolWindow -Caption +AlwaysOnTop +LastFound
	; Gui, -SysMenu
	; Gui, +LastFound
	; Gui, +E0x08000000
	; Gui, -Border
	; hWindow := WinExist()



	; PosX := A_CaretX + OffsetX
	; If PosX + MaxWidth > ScreenWidth ;past right side of the screen
	;     PosX := ScreenWidth - MaxWidth
	; PosY := A_CaretY + OffsetY
	; If PosY + BoxHeight > ScreenHeight ;past bottom of the screen
	;     PosY := ScreenHeight - BoxHeight
	Gui, Show, NA
 	; Gui, Show, AutoSize Center NoActivate





	; Output:
	ButtonOK:

	; If (A_GuiEvent != "" && A_GuiEvent != "DoubleClick")
	; 	return
		GuiControlGet, Output  ; Retrieve the ListBox's current selection.
		; MsgBox, 4,, %Output%
		; WinActivate Sublime
	    Send, % "{BS " . StrLen(Output) . "}" ;clear the typed word
	    SendRaw, %Output%
	    ; if output <> ""
	    ; {
	    ; 	Gui, Destroy
	    ; }
	return


	; ; return
	; GuiClose:
	; GuiEscape:
	; ; ExitApp
	; Gui, Destroy
	return
}

:*:woops::
ExitApp
return
