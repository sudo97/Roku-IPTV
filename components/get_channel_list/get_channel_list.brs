sub init()
    m.top.functionName = "getContent"
end sub
'http://ukr-iptv.com/list.m3u
sub getContent()
    searchRequest = CreateObject("roUrlTransfer")
    searchRequest.setURL(m.top.url)
    text = searchRequest.getToString()
'    print "recieved text"; text
    
    lines = CreateObject("roRegex", "\n", "").Split(text)
    
    regexEXT = CreateObject("roRegex", "#EXTINF:(.*)", "")
    
    arr = []
    
    for i = 1 to lines.Count()-1
        arr.Push({name: regexEXT.Replace(lines[i], "\1"), url: lines[i+1]})
        i = i + 1
    end for
    
    m.top.content = arr
end sub
