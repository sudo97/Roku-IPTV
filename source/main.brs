' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

sub Main()

 '   primaryfeed = getStrValFromReg("primaryfeed", "profile")
 '   print "Registry value is:"; primaryfeed
    
 '   success = saveStrValToReg("primaryfeed", primaryfeed, "profile")
   
'    showChannelSGScreen()

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    m.global = screen.getGlobalNode()
    scene = screen.CreateScene("MainScene")
    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
    
end sub

sub showChannelSGScreen()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    m.global = screen.getGlobalNode()
    scene = screen.CreateScene("MainScene")
    screen.show()
 
 
    

    while(true)
        msg = wait(0, m.port)
    msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while

end sub


Function getStrValFromReg(keyname As String, section As String) As String
    reg = CreateObject("roRegistrySection", section)
    if reg.Exists(keyname) then
        return reg.Read(keyname)
    endif
    return ""
End Function

Function saveStrValToReg(keyname As String, val As String, section As String) As Boolean
    reg = CreateObject("roRegistrySection", section)
    reg.Write(keyname, val)
    return reg.Flush()
End Function