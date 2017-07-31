sub init()
    print "initializing get_channel_list"
    m.top.functionName = "getContent"
end sub

sub getContent()

 primaryfeed = getStrValFromReg("primaryfeed", "profile")
 print "GET REGISTRY VALUE"; primaryfeed
 

xxx = m.global.feedurl
print "XXX feed is >>>>>>>>>>>> : " xxx

  print "entering getcontent";
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

    
  print "entering get to String"
  text = searchRequest.getToString()
  print "recieved text";
    
    reLineSplit = CreateObject ("roRegex", "(?>\r\n|[\r\n])", "")
    reExtinf = CreateObject ("roRegex", "(?i)^#EXTINF:\s*(\d+|-1|-0).*,\s*(.*)$", "")
    rePath = CreateObject ("roRegex", "^([^#].*)$", "")
    inExtinf = False
    con = CreateObject("roSGNode", "ContentNode")
    
   For Each line In reLineSplit.Split (text)

        If inExtinf
            maPath = rePath.Match (line)
            If maPath.Count () = 2
                item = con.CreateChild("ContentNode")
                item.url = maPath [1]
                item.title = title
                
                print "Title is >";item.title
                print "URL is >>>";item.url

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


