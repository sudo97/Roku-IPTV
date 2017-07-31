sub init()

print "Hello!?! .... in sub init() of get_feed_url.brs "

 primaryfeed = getStrValFromReg("primaryfeed", "profile")
 m.global.addFields( {feedurl: primaryfeed } )
 print "GLOBAL FEEDURL FROM get_FEED_URL";m.global.feedurl
   
end sub

Function getStrValFromReg(keyname As String, section As String) As String
    reg = CreateObject("roRegistrySection", section)
    if reg.Exists(keyname) then
        return reg.Read(keyname)
 '      return "https://pastebin.com/raw/v0dE8SdX"   'skip registry and load demo for testing'
        else
        return "https://pastebin.com/raw/v0dE8SdX"   'demo playlist of public streams
    endif
    return ""
End Function

Function saveStrValToReg(keyname As String, val As String, section As String) As Boolean
    reg = CreateObject("roRegistrySection", section)
    reg.Write(keyname, val)
    return reg.Flush()
End Function
