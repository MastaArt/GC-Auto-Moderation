/*  
[INFO] 
NAME=Great Catalog Auto Moderation Installer
AUTHOR=Vasyl Lukianenko
DEV=3DGROUND
DEV_WEB=https://3dground.net/
HELP=

MACRO=GC_Auto_Moderation
CAT=GreatCatalog
TXT=GC Auto Moderation
RUN=GC-Auto-Moderation.ms
VER=1.0.0

[SCRIPT]
*/

struct installGCMerger (
    currentPath = getFileNamePath (getThisScriptFileName()),
    manifest = getThisScriptFileName(),
        
    fn settings k s: "INFO" = (
        return getINISetting this.manifest s k
    ),
    
    macro = this.settings "MACRO",
    cat = this.settings "CAT",
    txt = this.settings "TXT",
    run = this.settings "RUN",
    ver = this.settings "VER",
    embedPath = substituteString this.currentPath @"\" "\\\\",
    upd = this.embedPath + "update.ms",
    script = this.embedPath + this.run,
	iconFile = "GC",

    fn installMacroScript = (
        local exec = ""
        exec += "macroScript " + this.macro + "\n"
        exec += "buttontext: \"" + this.txt + "\"\n"
        exec += "category: \"" + this.cat + "\"\n"
        exec += "icon: #(\"" + this.iconFile + "\", 1)\n"
        exec += "(\n"
        exec += "\ton execute do (\n"
        exec += "\t\tlocal s = \"" + this.script + "\"\n"
        exec += "\t\tlocal u = \"" + this.upd + "\"\n"
        exec += "\t\ttry(fileIn(s)) catch(messageBox \"Script not found! Download " + this.txt + " again!\" title: \"Error!\")\n"
        exec += "\t\ttry(fileIn(u)) catch()\n"
        exec += "\t)\n"
        exec += ")\n"
        
        try (execute exec) catch (print "Can't install MacroScript")
    ),
    
    fn addQuadMenuButton remove: false = (
        local quadMenu = menuMan.getViewportRightClickMenu #nonePressed
        local theMenu = quadMenu.getMenu 1
        
        fn findMenuItem theMenu menuName = (
            for i in 1 to theMenu.numItems() where (theMenu.getItem i).getTitle() == menuName do return i
            return 0
        )
        
        fn unregisterMenuItem theMenu menuName = (
            try (
                for i in 1 to theMenu.numItems() do (
                    if((theMenu.getItem i).getTitle() == menuName) do (
                        theMenu.removeItemByPosition i 
                        
                        if((theMenu.getItem (i - 1)).getIsSeparator()) do theMenu.removeItemByPosition (i - 1)
                    )
                )
            ) catch()
        )
        
        local item = try(findMenuItem theMenu "Select &Similar") catch (6)
        
        unregisterMenuItem theMenu this.txt
        
        if(not remove) do (
            quadItem = menuMan.createActionItem this.macro (this.cat)
            theMenu.addItem quadItem (item += 1)
        )
            
        menuMan.updateMenuBar()
    ),
    
    fn getNotes = (
        return getINISetting this.run this.ver
    ),
	
    on create do (
        local n = "\n"
        
        this.installMacroScript()
        
        addQuadMenuButton remove: true
        addQuadMenuButton remove: false
        
		colorman.reInitIcons()
		
        deleteFile (this.currentPath + "mzp.run")
        
        local m = n
        m += n
        m += "\t              " + this.txt + " installed successfully!" + "     " + n
        m += "\t==============================================" + n + n + n
        
        m += this.txt + " added automatically to Quad Menu!" + n + n + n
        m += "[!] To add a button to the toolbar:" + n
        m += " 1. Go to Customize User Interface" + n
        m += " 2. Tab: Toolbars" + n 
        m += " 3. Category: \"" + this.cat + "\"" + n
        m += " 4. Drag&Drop the \"" +  this.txt + "\" to toolbar" + n + n + n
        
        messageBox m title: "Installation"
        
        try (execute ("fileIn \"" + this.script + "\"")) catch ()
    )
)

installGCMerger()