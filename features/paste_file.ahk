HandlePasteAsFile() {
    if (DllCall("IsClipboardFormatAvailable", "uint", 15) && !HasClipboardImage())
        return

    stamp := FormatTime(, "MMdd-HHmmss")
    explorerDir := GetExplorerPath()

    isImg := HasClipboardImage()
    isTxt := (A_Clipboard != "")

    if (!isImg && !isTxt) {
        NotifyQoL("Clipboard Empty", "Nothing to paste as file.")
        return
    }

    ext := isImg ? "png" : "txt"
    prefix := isImg ? "snip" : "text"
    targetDir := (explorerDir != "") ? explorerDir : A_Temp
    baseName := prefix "-" stamp
    fileName := baseName "." ext
    targetPath := targetDir "\" fileName
    idx := 1
    while FileExist(targetPath) {
        fileName := baseName "-" idx "." ext
        targetPath := targetDir "\" fileName
        idx++
    }

    if (explorerDir != "") {
        saved := isImg ? SaveClipboardImageToFile(targetPath) : SaveClipboardTextToFile(targetPath)
        if saved
            NotifyQoL("File Created", fileName)
        else
            NotifyQoL("Save Failed", fileName)
        return
    }

    saved := isImg ? SaveClipboardImageToFile(targetPath) : SaveClipboardTextToFile(targetPath)
    if (saved && SetClipboardFileDrop(targetPath)) {
        NotifyQoL("File Ready to Paste", fileName)
    } else {
        NotifyQoL("Save Failed", fileName)
    }
}

ShouldPasteImagePath() {
    if !HasClipboardImageOnly()
        return false
    if !WinActive("ahk_class #32770")
        return false
    try {
        ctrl := ControlGetFocus("A")
        if ctrl {
            cls := ControlGetClassNN(ctrl)
            if RegExMatch(cls, "^Edit\d+$")
                return true
        }
        if ControlGetHwnd("Edit1", "A")
            return true
    }
    return false
}

PasteClipboardImagePath() {
    path := GetOrSaveTempClipboardImage()
    if (path = "") {
        SendInput("^v")
        return
    }

    try {
        ctrl := ControlGetFocus("A")
        if ctrl {
            cls := ControlGetClassNN(ctrl)
            if RegExMatch(cls, "^Edit\d+$") {
                EditPaste(path, cls, "A")
                return
            }
        }
    }

    if WinActive("ahk_class #32770") {
        try {
            ControlFocus("Edit1", "A")
            ControlSetText("", "Edit1", "A")
            EditPaste(path, "Edit1", "A")
            return
        }
    }

    SendText(path)
}
