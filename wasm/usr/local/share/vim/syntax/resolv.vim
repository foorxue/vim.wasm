if exists("b:current_syntax")
finish
endif
syn match resolvError /./
syn match resolvComment /\s*[#;].*$/
syn match resolvOperator /[\/:]/ contained
syn cluster resolvIPCluster contains=resolvIPError,resolvIPSpecial
syn match resolvIPError /\%(\d\{4,}\|25[6-9]\|2[6-9]\d\|[3-9]\d\{2}\)[\.0-9]*/ contained
syn match resolvIPSpecial /\%(127\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}\)/ contained
syn match resolvIP contained /\%(\d\{1,4}\.\)\{3}\d\{1,4}/ contains=@resolvIPCluster
syn match resolvIPNetmask contained /\%(\d\{1,4}\.\)\{3}\d\{1,4}\%(\/\%(\%(\d\{1,4}\.\)\{,3}\d\{1,4}\)\)\?/ contains=resolvOperator,@resolvIPCluster
syn match resolvHostname contained /\w\{-}\.[-0-9A-Za-z_\.]*/
syn match resolvIPNameserver contained /\%(\%(\d\{1,4}\.\)\{3}\d\{1,4}\%(\s\|$\)\)\+/ contains=@resolvIPCluster
syn match resolvHostnameSearch contained /\%(\%([-0-9A-Za-z_]\+\.\)*[-0-9A-Za-z_]\+\.\?\%(\s\|$\)\)\+/
syn match resolvIPNetmaskSortList contained /\%(\%(\d\{1,4}\.\)\{3}\d\{1,4}\%(\/\%(\%(\d\{1,4}\.\)\{,3}\d\{1,4}\)\)\?\%(\s\|$\)\)\+/ contains=resolvOperator,@resolvIPCluster
syn match resolvNameserver /^\s*nameserver\>/ nextgroup=resolvIPNameserver skipwhite
syn match resolvLwserver /^\s*lwserver\>/ nextgroup=resolvIPNameserver skipwhite
syn match resolvDomain /^\s*domain\>/ nextgroup=resolvHostname skipwhite
syn match resolvSearch /^\s*search\>/ nextgroup=resolvHostnameSearch skipwhite
syn match resolvSortList /^\s*sortlist\>/ nextgroup=resolvIPNetmaskSortList skipwhite
syn match resolvOptions /^\s*options\>/ nextgroup=resolvOption skipwhite
syn match resolvOption /\<\%(debug\|no_tld_query\|rotate\|no-check-names\|inet6\)\>/ contained nextgroup=resolvOption skipwhite
syn match resolvOption /\<\%(ndots\|timeout\|attempts\):\d\+\>/ contained contains=resolvOperator nextgroup=resolvOption skipwhite
syn match resolvError /^search .\{257,}/
hi def link resolvIP Number
hi def link resolvIPNetmask Number
hi def link resolvHostname String
hi def link resolvOption String
hi def link resolvIPNameserver Number
hi def link resolvHostnameSearch String
hi def link resolvIPNetmaskSortList Number
hi def link resolvNameServer Identifier
hi def link resolvLwserver Identifier
hi def link resolvDomain Identifier
hi def link resolvSearch Identifier
hi def link resolvSortList Identifier
hi def link resolvOptions Identifier
hi def link resolvComment Comment
hi def link resolvOperator Operator
hi def link resolvError Error
hi def link resolvIPError Error
hi def link resolvIPSpecial Special
let b:current_syntax = "resolv"