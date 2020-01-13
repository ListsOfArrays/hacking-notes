$json_file = gc .\http.log | ConvertFrom-Json

# $known_sqli = $json_file | Where-Object { $_.username -eq "' or '1=1" } | Select-Object -Property user_agent,uri,id.orig_h
# $known_uri = $json_file | Where-Object username -Match "\.\." | Select-Object -Property user_agent,uri,id.orig_h

# $known_sqli_extended = $json_file | Where-Object {$_.user_agent -in $known_sqli.user_agent -or $_."id.orig_h" -in $known_sqli."id.orig_h"}

# $iplist += find_bad_ips($known_sqli_extended)

#"1172119842:@localhost:65487/"
# "1211275882:@90.236.3.35/"
# $json_file | Select-Object uri | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern "<"
# $json_file | Select-Object uri | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern "\.\."
# $json_file | Select-Object uri | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern "'"
# $json_file | Select-Object user_agent | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern "'"
# $json_file | Select-Object user_agent | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern "{|}"
# $json_file | Select-Object user_agent | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern '>'
# $json_file | Select-Object host | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern '>'

# $json_file | Select-Object host,uri,user_agent | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern "'"
# $json_file | Select-Object host,uri,user_agent | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern '{|}'
# $json_file | Select-Object host,uri,user_agent | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern '>'
# $json_file | Select-Object host,uri,user_agent | ConvertTo-Csv | Sort-Object | Get-Unique | Select-String -Pattern '(\.[/\\])|(\.\.)'
#$superRegex ="(')|({)|(})|(>)|(<)|(\.[/\\])|(\.\.)|( or )|(\|\|)|" + '(")|(%)'
$superRegex = "(')|(>)|(<)|(\.\.)|( or )|" + '(")|(%)|(\./\|)|(\(\))|\||(/etc)|(\$)'
#$stations = "1000065|1162738|1259734|1265205|1265233|1272045|1273874|1283006|142363|1522503|1586288|1605549|1626128|1626289|1640598|1640765|1688145|169113|1705804|1706677|1711876|1714416|1729929|1790560|1793908|1803346|1804162|1804163|1806390|1817090|1817129|1863209|1886760|1975859|2023468|2027277|2066524|2169728|2177106|2208290|2228373|2261698|2272183|2325161|2354349|2387440|2448705|2514216|2517574|2525646|2525773|2542230|2638909|2638977|2648084|2650035|2654695|2661658|2725194|2732964|2736235|2737468|2741623|2744869|2753686|2769324|2782443|2785444|2799779|2803758|2805208|2807748|2822589|2822883|284324|2851317|2859926|2863401|2863482|2874545|2883920|2886159|2886446|2887290|2893414|2898076|2906499|2913408|2914999|2919256|2926132|2930270|2933706|2956955|2959676|2962928|2973164|2974263|2977681|2977953|2978325|2979342|2981925|2982863|2991921|2992770|2994310|3001191|3002369|3009652|3012033|3019016|3024695|3025365|3029023|3029523|3033500|3038561|3066385|3068478|3081652|3087383|3087896|3093133|3098865|3105575|3108799|3117791|3120292|3122407|3123897|3124136|3124751|3124894|3143034|3164172|3164504|3171546|3174463|3177021|3180871|3180909|3191130|3204817|3207527|3214108|3231905|323653|3312394|3333154|3407258|3409245|3429738|3436077|3439312|3448819|3449116|3513794|3526669|3532276|3576022|3584348|3595414|3595503|3617575|3667044|3687479|3702390|3837943|3838294|3859946|3864307|3980168|4018700|4031625|4095392|4272660|4343327|4440837|4469146|4494238|4537423|4613868|4652680|4723869|472663|4837799|4839843|4851902|4912555|4976012|5013156|5098214|5110077|5193011|5205704|5219189|5255015|527223|5273084|5277276|5427207|5477080|551877|566969|5742750|5779333|5807825|583589|5883213|588365|5948111|5974031|5990689|6059477|6115259|6176226|6295654|632539|6325480|6359434|6359739|6360516|6360911|6422018|6424663|6427532|6428085|6429576|6430872|6431141|6432478|6432496|6434319|6441230|6449010|6454368|6534348|6535279|6537804|6547674|654837|6548385|6550118|6550334|6550364|6550443|6551294|6551853|6552502|6552587|6552912|6553499|6553699|6553749|6554067|6554392|6555668|6556885|656913|6621545|662605|6690131|669904|679828|684230|6943603|6943829|694603|702491|7037393|7260320|7285519|7286553|730287|732745|736245|7511015|7522421|7533199|758605|758715|7601341|763765|7761466|7852592|7873618|7888015|7895303|8024080|8024142|8058329|8060286|8080017|8131393|8133962|8224783|875287"
#$stations = "1162738|1273874|1283006|142363|1626289|1711876|1729929|1817090|1975859|2023468|2169728|2177106|2208290|2261698|2732964|2737468|2753686|2785444|2807748|2822589|284324|2886446|2898076|2906499|2913408|2919256|2956955|2959676|2962928|2979342|2981925|2992770|3009652|3029523|3093133|3117791|3120292|3174463|3180871|3207527|3214108|3231905|3312394|3576022|3687479|3702390|3859946|4031625|4440837|4469146|4613868|4837799|5110077|527223|632539|6359434|6422018|6427532|6430872|6431141|6432478|6449010|6534348|654837|6548385|6550334|6550364|6551294|6551853|656913|669904|6943829|702491|7285519|730287|7511015|758605|7888015|8024142|8058329|8080017|8224783|875287"
$knownBadRequests = $json_file | Where-Object {$_.host -Match "$superRegex" -or $_.uri -Match "$superRegex" -or $_.user_agent -Match "$superRegex" -or $_.username -Match "$superRegex"}
#$knownBadRequests = $json_file | Where-Object {$_.host -Match "$superRegex" -or $_.uri -Match "$superRegex" -or $_.user_agent -Match "$superRegex" -or $_.username -Match "$superRegex" -or ($_.status_code -ne 200 -and $_.status_code -ne 304)}
([System.Collections.Generic.HashSet[string]] $useragent_set = $knownBadRequests.user_agent)
([System.Collections.Generic.HashSet[string]] $ip_set = $knownBadRequests."id.orig_h")
#$knownBadRequests = $json_file | Where-Object {$_.host -Match "$superRegex" -or $_.uri -Match "$superRegex" -or $_.user_agent -Match "$superRegex" -or $_.username -Match "$superRegex" -or $_.uri -Match "$stations"}
$otherBadRequests = $json_file | Where-Object {$_.user_agent -in $useragent_set -or $_."id.orig_h" -in $ip_set}

$iplist = $otherBadRequests | Where-Object uri -match "/api/measurements" | Where-Object method -eq POST | Select-Object -Property "id.orig_h" | Sort-Object

$iplist = $iplist | ConvertTo-Csv | Sort-Object | Get-Unique
$iplist.Length

$iplist
