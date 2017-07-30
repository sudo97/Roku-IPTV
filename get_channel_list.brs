sub init()
    print "initializing get_channel_list"
    m.top.functionName = "getContent"
end sub

sub getContent()

 primaryfeed = getStrValFromReg("primaryfeed", "profile")
 print "GET REGISTRY VALUE"; primaryfeed
 

xxx = m.global.feedurl
print "XXX feed is >>>>>>>>>>>> : " xxx

  print "entering getcontent"; text
    m.port = CreateObject ("roMessagePort")
    searchRequest = CreateObject("roUrlTransfer")
    searchRequest.setURL(xxx)
	

    searchRequest.EnableEncodings (True)
    https = "https:"
    If LCase (Left (xxx, Len (https))) = https
        searchRequest.SetCertificatesFile ("common:/certs/ca-bundle.crt")
        searchRequest.AddHeader ("X-Roku-Reserved-Dev-Id", "")
        searchRequest.InitClientCertificates ()
    Endif

	
	
  text = searchRequest.getToString()
  print "recieved text"; text
    
    lines = CreateObject("roRegex", "\n", "").Split(text)
    regexEXT = CreateObject("roRegex", "#EXTINF:(.*)", "")
'   rePath = CreateObject ("roRegex", "^([^#].*)$", "")
    con = CreateObject("roSGNode", "ContentNode")
    
    for i = 1 to lines.Count()-1
	item = con.CreateChild("ContentNode")
	item.title = regexEXT.Replace(lines[i], "\1")
	       item.StreamFormat = ""

'	item.url = rePath.Match (lines[i+1])
	item.url = lines[i+1].Replace(chr(13), "")
	item.url = item.url.Replace(chr(10),"")
'	item.url = left(lines[i+1], Len(lines[i+1])-1)
'	print Len(lines[i+1])
    print item.url

        i = i + 1
    end for
    
    m.top.content = con
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

' Quick 'N Dirty M3U8 Parser (having issues)
Function parseIndex (indexString As String) As Object
    m3u8List = []
    reLineSplit = CreateObject ("roRegex", "(?>\r\n|[\r\n])", "")
    reExtinf = CreateObject ("roRegex", "^#EXTINF:\s*(\d+|-1)\s*,\s*(.*)$", "")
    rePath = CreateObject ("roRegex", "^([^#].*)$", "")
    inExtinf = False
    For Each line In reLineSplit.Split (indexString)
        If inExtinf
            maPath = rePath.Match (line)
            If maPath.Count () = 2
                path = maPath [1]
                m3u8List.Push ({
                    Title: title,
                    Length: length,
                    Stream: {Url: path}
                    StreamFormat: "hls"
                    SwitchingStrategy: "full-adaptation"
                })
                inExtinf = False
            Endif
        Endif
        maExtinf = reExtinf.Match (line)
        If maExtinf.Count () = 3
            length = maExtinf [1].ToInt ()
            If length < 0 Then length = 0
            title = maExtinf [2]
            inExtinf = True
        Endif
    End For
    Return m3u8List
End Function 
