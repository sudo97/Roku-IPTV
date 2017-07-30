sub init()
    print "initializing save_feed_url"
    m.top.functionName = "saveurl"
end sub

sub saveurl()

    print "GLOBAL FEEDURL to SAVE to Registry";m.global.feedurl
    reg = CreateObject("roRegistrySection",  "profile")
    reg.Write("primaryfeed", m.global.feedurl)
    reg.Flush()
    
End sub

