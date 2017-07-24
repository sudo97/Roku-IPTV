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
    
    con = CreateObject("roSGNode", "ContentNode")
    
    for i = 1 to lines.Count()-1
	item = con.CreateChild("ContentNode")
	item.title = regexEXT.Replace(lines[i], "\1")
	item.url = lines[i+1]
        i = i + 1
    end for
    
    m.top.content = con
end sub
