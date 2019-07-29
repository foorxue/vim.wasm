if exists("b:current_syntax")
finish
endif
if getline(1) =~ '\<ksh$'
let b:is_kornshell = 1
elseif getline(1) =~ '\<bash$'
let b:is_bash      = 1
elseif getline(1) =~ '\<dash$'
let b:is_posix     = 1
elseif !exists("g:is_kornshell") && !exists("g:is_bash") && !exists("g:is_posix") && !exists("g:is_sh")
let s:shell = ""
if executable("/bin/sh")
let s:shell = resolve("/bin/sh")
elseif executable("/usr/bin/sh")
let s:shell = resolve("/usr/bin/sh")
endif
if     s:shell =~ 'ksh$'
let b:is_kornshell= 1
elseif s:shell =~ 'bash$'
let b:is_bash = 1
elseif s:shell =~ 'dash$'
let b:is_posix = 1
endif
unlet s:shell
endif
if !exists("b:is_kornshell") && !exists("b:is_bash")
if exists("g:is_posix") && !exists("g:is_kornshell")
let g:is_kornshell= g:is_posix
endif
if exists("g:is_kornshell")
let b:is_kornshell= 1
if exists("b:is_sh")
unlet b:is_sh
endif
elseif exists("g:is_bash")
let b:is_bash= 1
if exists("b:is_sh")
unlet b:is_sh
endif
else
let b:is_sh= 1
endif
endif
if !exists("g:sh_fold_enabled")
let g:sh_fold_enabled= 0
elseif g:sh_fold_enabled != 0 && !has("folding")
let g:sh_fold_enabled= 0
echomsg "Ignoring g:sh_fold_enabled=".g:sh_fold_enabled."; need to re-compile vim for +fold support"
endif
if !exists("s:sh_fold_functions")
let s:sh_fold_functions= and(g:sh_fold_enabled,1)
endif
if !exists("s:sh_fold_heredoc")
let s:sh_fold_heredoc  = and(g:sh_fold_enabled,2)
endif
if !exists("s:sh_fold_ifdofor")
let s:sh_fold_ifdofor  = and(g:sh_fold_enabled,4)
endif
if g:sh_fold_enabled && &fdm == "manual"
setl fdm=syntax
endif
if (v:version == 704 && has("patch-7.4.1142")) || v:version > 704
if exists("b:is_bash")
exe "syn iskeyword ".&iskeyword.",-,:"
else
exe "syn iskeyword ".&iskeyword.",-"
endif
endif
if s:sh_fold_functions
com! -nargs=* ShFoldFunctions <args> fold
else
com! -nargs=* ShFoldFunctions <args>
endif
if s:sh_fold_heredoc
com! -nargs=* ShFoldHereDoc <args> fold
else
com! -nargs=* ShFoldHereDoc <args>
endif
if s:sh_fold_ifdofor
com! -nargs=* ShFoldIfDoFor <args> fold
else
com! -nargs=* ShFoldIfDoFor <args>
endif
syn case match
syn cluster shErrorList	contains=shDoError,shIfError,shInError,shCaseError,shEsacError,shCurlyError,shParenError,shTestError,shOK
if exists("b:is_kornshell") || exists("b:is_bash")
syn cluster ErrorList add=shDTestError
endif
syn cluster shArithParenList	contains=shArithmetic,shCaseEsac,shComment,shDeref,shDo,shDerefSimple,shEcho,shEscape,shNumber,shOperator,shPosnParm,shExSingleQuote,shExDoubleQuote,shHereString,shRedir,shSingleQuote,shDoubleQuote,shStatement,shVariable,shAlias,shTest,shCtrlSeq,shSpecial,shParen,bashSpecialVariables,bashStatement,shIf,shFor
syn cluster shArithList	contains=@shArithParenList,shParenError
syn cluster shCaseEsacList	contains=shCaseStart,shCaseLabel,shCase,shCaseBar,shCaseIn,shComment,shDeref,shDerefSimple,shCaseCommandSub,shCaseExSingleQuote,shCaseSingleQuote,shCaseDoubleQuote,shCtrlSeq,@shErrorList,shStringSpecial,shCaseRange
syn cluster shCaseList	contains=@shCommandSubList,shCaseEsac,shColon,shCommandSub,shCommandSubBQ,shComment,shDo,shEcho,shExpr,shFor,shForPP,shHereDoc,shIf,shHereString,shRedir,shSetList,shSource,shStatement,shVariable,shCtrlSeq
syn cluster shCommandSubList	contains=shAlias,shArithmetic,shCmdParenRegion,shCommandSub,shComment,shCtrlSeq,shDeref,shDerefSimple,shDoubleQuote,shEcho,shEscape,shExDoubleQuote,shExpr,shExSingleQuote,shHereDoc,shNumber,shOperator,shOption,shPosnParm,shHereString,shRedir,shSingleQuote,shSpecial,shStatement,shSubSh,shTest,shVariable
syn cluster shCurlyList	contains=shNumber,shComma,shDeref,shDerefSimple,shDerefSpecial
syn cluster shDblQuoteList	contains=shArithmetic,shCommandSub,shCommandSubBQ,shDeref,shDerefSimple,shEscape,shPosnParm,shCtrlSeq,shSpecial,shSpecialDQ
syn cluster shDerefList	contains=shDeref,shDerefSimple,shDerefVar,shDerefSpecial,shDerefWordError,shDerefPSR,shDerefPPS
syn cluster shDerefVarList	contains=shDerefOff,shDerefOp,shDerefVarArray,shDerefOpError
syn cluster shEchoList	contains=shArithmetic,shCommandSub,shCommandSubBQ,shDeref,shDerefSimple,shEscape,shExSingleQuote,shExDoubleQuote,shSingleQuote,shDoubleQuote,shCtrlSeq,shEchoQuote
syn cluster shExprList1	contains=shCharClass,shNumber,shOperator,shExSingleQuote,shExDoubleQuote,shSingleQuote,shDoubleQuote,shExpr,shDblBrace,shDeref,shDerefSimple,shCtrlSeq
syn cluster shExprList2	contains=@shExprList1,@shCaseList,shTest
syn cluster shFunctionList	contains=@shCommandSubList,shCaseEsac,shColon,shComment,shDo,shEcho,shExpr,shFor,shHereDoc,shIf,shOption,shHereString,shRedir,shSetList,shSource,shStatement,shVariable,shOperator,shCtrlSeq
if exists("b:is_kornshell") || exists("b:is_bash")
syn cluster shFunctionList	add=shRepeat
syn cluster shFunctionList	add=shDblBrace,shDblParen
endif
syn cluster shHereBeginList	contains=@shCommandSubList
syn cluster shHereList	contains=shBeginHere,shHerePayload
syn cluster shHereListDQ	contains=shBeginHere,@shDblQuoteList,shHerePayload
syn cluster shIdList	contains=shCommandSub,shCommandSubBQ,shWrapLineOperator,shSetOption,shComment,shDeref,shDerefSimple,shHereString,shNumber,shOperator,shRedir,shExSingleQuote,shExDoubleQuote,shSingleQuote,shDoubleQuote,shExpr,shCtrlSeq,shStringSpecial,shAtExpr
syn cluster shIfList	contains=@shLoopList,shDblBrace,shDblParen,shFunctionKey,shFunctionOne,shFunctionTwo
syn cluster shLoopList	contains=@shCaseList,@shErrorList,shCaseEsac,shConditional,shDblBrace,shExpr,shFor,shForPP,shIf,shOption,shSet,shTest,shTestOpr,shTouch
syn cluster shPPSRightList	contains=shComment,shDeref,shDerefSimple,shEscape,shPosnParm
syn cluster shSubShList	contains=@shCommandSubList,shCommandSubBQ,shCaseEsac,shColon,shCommandSub,shComment,shDo,shEcho,shExpr,shFor,shIf,shHereString,shRedir,shSetList,shSource,shStatement,shVariable,shCtrlSeq,shOperator
syn cluster shTestList	contains=shArithmetic,shCharClass,shCommandSub,shCommandSubBQ,shCtrlSeq,shDeref,shDerefSimple,shDoubleQuote,shSpecialDQ,shExDoubleQuote,shExpr,shExSingleQuote,shNumber,shOperator,shSingleQuote,shTest,shTestOpr
syn cluster shNoZSList	contains=shSpecialNoZS
syn cluster shForList	contains=shTestOpr,shNumber,shDerefSimple,shDeref,shCommandSub,shCommandSubBQ,shArithmetic
syn region shEcho matchgroup=shStatement start="\<echo\>"  skip="\\$" matchgroup=shEchoDelim end="$" matchgroup=NONE end="[<>;&|()`]"me=e-1 end="\d[<>]"me=e-2 end="\s#"me=e-2 contains=@shEchoList skipwhite nextgroup=shQuickComment
syn region shEcho matchgroup=shStatement start="\<print\>" skip="\\$" matchgroup=shEchoDelim end="$" matchgroup=NONE end="[<>;&|()`]"me=e-1 end="\d[<>]"me=e-2 end="\s#"me=e-2 contains=@shEchoList skipwhite nextgroup=shQuickComment
syn match  shEchoQuote contained	'\%(\\\\\)*\\["`'()]'
syn region shEmbeddedEcho contained matchgroup=shStatement start="\<print\>" skip="\\$" matchgroup=shEchoDelim end="$" matchgroup=NONE end="[<>;&|`)]"me=e-1 end="\d[<>]"me=e-2 end="\s#"me=e-2 contains=shNumber,shExSingleQuote,shSingleQuote,shDeref,shDerefSimple,shSpecialVar,shOperator,shExDoubleQuote,shDoubleQuote,shCharClass,shCtrlSeq
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_posix")
syn match shStatement "\<alias\>"
syn region shAlias matchgroup=shStatement start="\<alias\>\s\+\(\h[-._[:alnum:]]\+\)\@="  skip="\\$" end="\>\|`"
syn region shAlias matchgroup=shStatement start="\<alias\>\s\+\(\h[-._[:alnum:]]\+=\)\@=" skip="\\$" end="="
syn match shTouch	'\<touch\>[^;#]*'	skipwhite nextgroup=shComment contains=shTouchCmd,shDoubleQuote,shSingleQuote,shDeref,shDerefSimple
syn match shTouchCmd	'\<touch\>'		contained
endif
if !exists("g:sh_no_error")
syn match   shDoError "\<done\>"
syn match   shIfError "\<fi\>"
syn match   shInError "\<in\>"
syn match   shCaseError ";;"
syn match   shEsacError "\<esac\>"
syn match   shCurlyError "}"
syn match   shParenError ")"
syn match   shOK	'\.\(done\|fi\|in\|esac\)'
if exists("b:is_kornshell") || exists("b:is_bash")
syn match     shDTestError "]]"
endif
syn match     shTestError "]"
endif
syn match   shOption	"\s\zs[-+][-_a-zA-Z#@]\+"
syn match   shOption	"\s\zs--[^ \t$`'"|);]\+"
syn match      shRedir	"\d\=>\(&[-0-9]\)\="
syn match      shRedir	"\d\=>>-\="
syn match      shRedir	"\d\=<\(&[-0-9]\)\="
syn match      shRedir	"\d<<-\="
syn match   shOperator	"<<\|>>"		contained
syn match   shOperator	"[!&;|]"		contained
syn match   shOperator	"\[[[^:]\|\]]"		contained
syn match   shOperator	"[-=/*+%]\=="		skipwhite nextgroup=shPattern
syn match   shPattern	"\<\S\+\())\)\@="	contained contains=shExSingleQuote,shSingleQuote,shExDoubleQuote,shDoubleQuote,shDeref
syn region shExpr  transparent matchgroup=shExprRegion  start="{" end="}"		contains=@shExprList2 nextgroup=shSpecialNxt
syn region shSubSh transparent matchgroup=shSubShRegion start="[^(]\zs(" end=")"	contains=@shSubShList nextgroup=shSpecialNxt
syn region shExpr	matchgroup=shRange start="\[" skip=+\\\\\|\\$\|\[+ end="\]" contains=@shTestList,shSpecial
syn region shTest	transparent matchgroup=shStatement start="\<test\s" skip=+\\\\\|\\$+ matchgroup=NONE end="[;&|]"me=e-1 end="$" contains=@shExprList1
syn region shNoQuote	start='\S'	skip='\%(\\\\\)*\\.'	end='\ze\s' end="\ze['"]"	contained contains=shDerefSimple,shDeref
syn match  shAstQuote	contained	'\*\ze"'	nextgroup=shString
syn match  shTestOpr	contained	'[^-+/%]\zs=' skipwhite nextgroup=shTestDoubleQuote,shTestSingleQuote,shTestPattern
syn match  shTestOpr	contained	"<=\|>=\|!=\|==\|=\~\|-.\>\|-\(nt\|ot\|ef\|eq\|ne\|lt\|le\|gt\|ge\)\>\|[!<>]"
syn match  shTestPattern	contained	'\w\+'
syn region shTestDoubleQuote	contained	start='\%(\%(\\\\\)*\\\)\@<!"' skip=+\\\\\|\\"+ end='"'	contains=shDeref,shDerefSimple,shDerefSpecial
syn match  shTestSingleQuote	contained	'\\.'	nextgroup=shTestSingleQuote
syn match  shTestSingleQuote	contained	"'[^']*'"
if exists("b:is_kornshell") || exists("b:is_bash")
syn region  shDblBrace matchgroup=Delimiter start="\[\["	skip=+\%(\\\\\)*\\$+ end="\]\]"	contains=@shTestList,shAstQuote,shNoQuote,shComment
syn region  shDblParen matchgroup=Delimiter start="(("	skip=+\%(\\\\\)*\\$+ end="))"	contains=@shTestList,shComment
endif
syn match   shCharClass	contained	"\[:\(backspace\|escape\|return\|xdigit\|alnum\|alpha\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|tab\):\]"
ShFoldIfDoFor syn region shDo	transparent	matchgroup=shConditional start="\<do\>" matchgroup=shConditional end="\<done\>"			contains=@shLoopList
ShFoldIfDoFor syn region shIf	transparent	matchgroup=shConditional start="\<if\_s" matchgroup=shConditional skip=+-fi\>+ end="\<;\_s*then\>" end="\<fi\>"	contains=@shIfList
ShFoldIfDoFor syn region shFor		matchgroup=shLoop start="\<for\ze\_s\s*\%(((\)\@!" end="\<in\>" end="\<do\>"me=e-2			contains=@shLoopList,shDblParen skipwhite nextgroup=shCurlyIn
ShFoldIfDoFor syn region shForPP	matchgroup=shLoop start='\<for\>\_s*((' end='))' contains=@shForList
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_posix")
syn cluster shCaseList	add=shRepeat
syn cluster shFunctionList	add=shRepeat
syn region shRepeat   matchgroup=shLoop   start="\<while\_s" end="\<do\>"me=e-2	contains=@shLoopList,shDblParen,shDblBrace
syn region shRepeat   matchgroup=shLoop   start="\<until\_s" end="\<do\>"me=e-2	contains=@shLoopList,shDblParen,shDblBrace
if !exists("b:is_posix")
syn region shCaseEsac matchgroup=shConditional start="\<select\s" matchgroup=shConditional end="\<in\>" end="\<do\>" contains=@shLoopList
endif
else
syn region shRepeat   matchgroup=shLoop   start="\<while\_s" end="\<do\>"me=e-2		contains=@shLoopList
syn region shRepeat   matchgroup=shLoop   start="\<until\_s" end="\<do\>"me=e-2		contains=@shLoopList
endif
syn region shCurlyIn   contained	matchgroup=Delimiter start="{" end="}" contains=@shCurlyList
syn match  shComma     contained	","
syn match shCaseBar	contained skipwhite "\(^\|[^\\]\)\(\\\\\)*\zs|"		nextgroup=shCase,shCaseStart,shCaseBar,shComment,shCaseExSingleQuote,shCaseSingleQuote,shCaseDoubleQuote
syn match shCaseStart	contained skipwhite skipnl "("			nextgroup=shCase,shCaseBar
syn match shCaseLabel	contained skipwhite	"\%(\\.\|[-a-zA-Z0-9_*.]\)\+"	contains=shCharClass
if exists("b:is_bash")
ShFoldIfDoFor syn region	shCase	contained skipwhite skipnl matchgroup=shSnglCase start="\%(\\.\|[^#$()'" \t]\)\{-}\zs)"  end=";;" end=";&" end=";;&" end="esac"me=s-1	contains=@shCaseList	nextgroup=shCaseStart,shCase,shComment
else                                                                                                                     
ShFoldIfDoFor syn region	shCase	contained skipwhite skipnl matchgroup=shSnglCase start="\%(\\.\|[^#$()'" \t]\)\{-}\zs)"  end=";;" end="esac"me=s-1		contains=@shCaseList	nextgroup=shCaseStart,shCase,shComment
endif
ShFoldIfDoFor syn region	shCaseEsac	matchgroup=shConditional start="\<case\>" end="\<esac\>"	contains=@shCaseEsacList
syn keyword shCaseIn	contained skipwhite skipnl in			nextgroup=shCase,shCaseStart,shCaseBar,shComment,shCaseExSingleQuote,shCaseSingleQuote,shCaseDoubleQuote
if exists("b:is_bash")
syn region  shCaseExSingleQuote	matchgroup=shQuote start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial,shSpecial	skipwhite skipnl nextgroup=shCaseBar	contained
elseif !exists("g:sh_no_error")
syn region  shCaseExSingleQuote	matchgroup=Error start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial	skipwhite skipnl nextgroup=shCaseBar	contained
endif
syn region  shCaseSingleQuote	matchgroup=shQuote start=+'+ end=+'+		contains=shStringSpecial		skipwhite skipnl nextgroup=shCaseBar	contained
syn region  shCaseDoubleQuote	matchgroup=shQuote start=+"+ skip=+\\\\\|\\.+ end=+"+	contains=@shDblQuoteList,shStringSpecial	skipwhite skipnl nextgroup=shCaseBar	contained
syn region  shCaseCommandSub	start=+`+ skip=+\\\\\|\\.+ end=+`+		contains=@shCommandSubList		skipwhite skipnl nextgroup=shCaseBar	contained
if exists("b:is_bash")
syn region  shCaseRange	matchgroup=Delimiter start=+\[+ skip=+\\\\+ end=+\]+	contained	contains=shCharClass
syn match   shCharClass	'\[:\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|word\|or\|xdigit\):\]'			contained
else
syn region  shCaseRange	matchgroup=Delimiter start=+\[+ skip=+\\\\+ end=+\]+	contained
endif
syn match   shWrapLineOperator "\\$"
syn region  shCommandSubBQ   	start="`" skip="\\\\\|\\." end="`"	contains=shBQComment,@shCommandSubList
syn match   shEscape	contained	'\%(^\)\@!\%(\\\\\)*\\.'	nextgroup=shComment
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_posix")
syn region shCommandSub matchgroup=shCmdSubRegion start="\$("  skip='\\\\\|\\.' end=")"  contains=@shCommandSubList
syn region shArithmetic matchgroup=shArithRegion  start="\$((" skip='\\\\\|\\.' end="))" contains=@shArithList
syn region shArithmetic matchgroup=shArithRegion  start="\$\[" skip='\\\\\|\\.' end="\]" contains=@shArithList
syn match  shSkipInitWS contained	"^\s\+"
elseif !exists("g:sh_no_error")
syn region shCommandSub matchgroup=Error start="\$(" end=")" contains=@shCommandSubList
endif
syn region shCmdParenRegion matchgroup=shCmdSubRegion start="(\ze[^(]" skip='\\\\\|\\.' end=")" contains=@shCommandSubList
if exists("b:is_bash")
syn cluster shCommandSubList add=bashSpecialVariables,bashStatement
syn cluster shCaseList add=bashAdminStatement,bashStatement
syn keyword bashSpecialVariables contained auto_resume BASH BASH_ALIASES BASH_ALIASES BASH_ARGC BASH_ARGC BASH_ARGV BASH_ARGV BASH_CMDS BASH_CMDS BASH_COMMAND BASH_COMMAND BASH_ENV BASH_EXECUTION_STRING BASH_EXECUTION_STRING BASH_LINENO BASH_LINENO BASHOPTS BASHOPTS BASHPID BASHPID BASH_REMATCH BASH_REMATCH BASH_SOURCE BASH_SOURCE BASH_SUBSHELL BASH_SUBSHELL BASH_VERSINFO BASH_VERSION BASH_XTRACEFD BASH_XTRACEFD CDPATH COLUMNS COLUMNS COMP_CWORD COMP_CWORD COMP_KEY COMP_KEY COMP_LINE COMP_LINE COMP_POINT COMP_POINT COMPREPLY COMPREPLY COMP_TYPE COMP_TYPE COMP_WORDBREAKS COMP_WORDBREAKS COMP_WORDS COMP_WORDS COPROC COPROC DIRSTACK EMACS EMACS ENV ENV EUID FCEDIT FIGNORE FUNCNAME FUNCNAME FUNCNEST FUNCNEST GLOBIGNORE GROUPS histchars HISTCMD HISTCONTROL HISTFILE HISTFILESIZE HISTIGNORE HISTSIZE HISTTIMEFORMAT HISTTIMEFORMAT HOME HOSTFILE HOSTNAME HOSTTYPE IFS IGNOREEOF INPUTRC LANG LC_ALL LC_COLLATE LC_CTYPE LC_CTYPE LC_MESSAGES LC_NUMERIC LC_NUMERIC LINENO LINES LINES MACHTYPE MAIL MAILCHECK MAILPATH MAPFILE MAPFILE OLDPWD OPTARG OPTERR OPTIND OSTYPE PATH PIPESTATUS POSIXLY_CORRECT POSIXLY_CORRECT PPID PROMPT_COMMAND PS1 PS2 PS3 PS4 PWD RANDOM READLINE_LINE READLINE_LINE READLINE_POINT READLINE_POINT REPLY SECONDS SHELL SHELL SHELLOPTS SHLVL TIMEFORMAT TIMEOUT TMPDIR TMPDIR UID
syn keyword bashStatement chmod clear complete du egrep expr fgrep find gnufind gnugrep grep less ls mkdir mv rm rmdir rpm sed sleep sort strip tail
syn keyword bashAdminStatement daemon killall killproc nice reload restart start status stop
syn keyword bashStatement	command compgen
endif
if exists("b:is_kornshell") || exists("b:is_posix")
syn cluster shCommandSubList add=kshSpecialVariables,kshStatement
syn cluster shCaseList add=kshStatement
syn keyword kshSpecialVariables contained CDPATH COLUMNS EDITOR ENV ERRNO FCEDIT FPATH HISTFILE HISTSIZE HOME IFS LINENO LINES MAIL MAILCHECK MAILPATH OLDPWD OPTARG OPTIND PATH PPID PS1 PS2 PS3 PS4 PWD RANDOM REPLY SECONDS SHELL TMOUT VISUAL
syn keyword kshStatement cat chmod clear cp du egrep expr fgrep find grep killall less ls mkdir mv nice printenv rm rmdir sed sort strip stty tail tput
syn keyword kshStatement command setgroups setsenv
endif
syn match   shSource	"^\.\s"
syn match   shSource	"\s\.\s"
if exists("b:is_kornshell") || exists("b:is_posix")
syn match   shColon	'^\s*\zs:'
endif
syn match   shNumber	"\<\d\+\>#\="
syn match   shNumber	"\<-\=\.\=\d\+\>#\="
syn match   shCtrlSeq	"\\\d\d\d\|\\[abcfnrtv0]"			contained
if exists("b:is_bash")
syn match   shSpecial	"[^\\]\(\\\\\)*\zs\\\o\o\o\|\\x\x\x\|\\c[^"]\|\\[abefnrtv]"	contained
syn match   shSpecial	"^\(\\\\\)*\zs\\\o\o\o\|\\x\x\x\|\\c[^"]\|\\[abefnrtv]"	contained
syn region  shExSingleQuote	matchgroup=shQuote start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial,shSpecial		nextgroup=shSpecialNxt
syn region  shExDoubleQuote	matchgroup=shQuote start=+\$"+ skip=+\\\\\|\\.\|\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial,shSpecial	nextgroup=shSpecialNxt
elseif !exists("g:sh_no_error")
syn region  shExSingleQuote	matchGroup=Error start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial
syn region  shExDoubleQuote	matchGroup=Error start=+\$"+ skip=+\\\\\|\\.+ end=+"+	contains=shStringSpecial
endif
syn region  shSingleQuote	matchgroup=shQuote start=+'+ end=+'+		contains=@Spell	nextgroup=shSpecialStart,shSpecialSQ
syn region  shDoubleQuote	matchgroup=shQuote start=+\%(\%(\\\\\)*\\\)\@<!"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial,@Spell	nextgroup=shSpecialStart
syn region  shDoubleQuote	matchgroup=shQuote start=+"+ skip=+\\"+ end=+"+		contained contains=@shDblQuoteList,shStringSpecial,@Spell	nextgroup=shSpecialStart
syn match   shStringSpecial	"[^[:print:] \t]"			contained
syn match   shStringSpecial	"[^\\]\zs\%(\\\\\)*\\[\\"'`$()#]"			nextgroup=shComment
syn match   shSpecialSQ	"[^\\]\zs\%(\\\\\)*\\[\\"'`$()#]"		contained	nextgroup=shBkslshSnglQuote,@shNoZSList
syn match   shSpecialDQ	"[^\\]\zs\%(\\\\\)*\\[\\"'`$()#]"		contained	nextgroup=shBkslshDblQuote,@shNoZSList
syn match   shSpecialStart	"\%(\\\\\)*\\[\\"'`$()#]"			contained	nextgroup=shBkslshSnglQuote,shBkslshDblQuote,@shNoZSList
syn match   shSpecial	"^\%(\\\\\)*\\[\\"'`$()#]"
syn match   shSpecialNoZS	contained	"\%(\\\\\)*\\[\\"'`$()#]"
syn match   shSpecialNxt	contained	"\\[\\"'`$()#]"
syn region  shBkslshSnglQuote	contained	matchgroup=shQuote start=+'+ end=+'+	contains=@Spell	nextgroup=shSpecialStart
syn region  shBkslshDblQuote	contained	matchgroup=shQuote start=+"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial,@Spell	nextgroup=shSpecialStart
syn cluster	shCommentGroup	contains=shTodo,@Spell
if exists("b:is_bash")
syn match	shTodo	contained		"\<\%(COMBAK\|FIXME\|TODO\|XXX\)\ze:\=\>"
else
syn keyword	shTodo	contained		COMBAK FIXME TODO XXX
endif
syn match	shComment		"^\s*\zs#.*$"	contains=@shCommentGroup
syn match	shComment		"\s\zs#.*$"	contains=@shCommentGroup
syn match	shComment	contained	"#.*$"	contains=@shCommentGroup
syn match	shQuickComment	contained	"#.*$"
syn match	shBQComment	contained	"#.\{-}\ze`"	contains=@shCommentGroup
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc01 start="<<\s*\\\=\z([^ \t|>]\+\)"		matchgroup=shHereDoc01 end="^\z1\s*$"	contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc02 start="<<\s*\"\z([^"]\+\)\""		matchgroup=shHereDoc02 end="^\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc03 start="<<-\s*\z([^ \t|>]\+\)"		matchgroup=shHereDoc03 end="^\s*\z1\s*$"	contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc04 start="<<-\s*'\z([^']\+\)'"		matchgroup=shHereDoc04 end="^\s*\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc05 start="<<\s*'\z([^']\+\)'"		matchgroup=shHereDoc05 end="^\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc06 start="<<-\s*\"\z([^"]\+\)\""		matchgroup=shHereDoc06 end="^\s*\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc07 start="<<\s*\\\_$\_s*\z([^ \t'"|>]\+\)"	matchgroup=shHereDoc07 end="^\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc08 start="<<\s*\\\_$\_s*'\z([^\t|>]\+\)'"	matchgroup=shHereDoc08 end="^\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc09 start="<<\s*\\\_$\_s*\"\z([^\t|>]\+\)\""	matchgroup=shHereDoc09 end="^\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc10 start="<<-\s*\\\_$\_s*\z([^ \t|>]\+\)"	matchgroup=shHereDoc10 end="^\s*\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc11 start="<<-\s*\\\_$\_s*\\\z([^ \t|>]\+\)"	matchgroup=shHereDoc11 end="^\s*\z1\s*$"        contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc12 start="<<-\s*\\\_$\_s*'\z([^']\+\)'"		matchgroup=shHereDoc12 end="^\s*\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc13 start="<<-\s*\\\_$\_s*\"\z([^"]\+\)\""	matchgroup=shHereDoc13 end="^\s*\z1\s*$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc14 start="<<\\\z([^ \t|>]\+\)"		matchgroup=shHereDoc14 end="^\z1\s*$"           contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc15 start="<<-\s*\\\z([^ \t|>]\+\)"		matchgroup=shHereDoc15 end="^\s*\z1\s*$"        contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc16 start="<<-\s*\\\z([^ \t|>]\+\)"		matchgroup=shHereDoc15 end="^\s*\z1\s*$"        contains=@shDblQuoteList
if exists("b:is_bash") || (exists("b:is_kornshell") && !exists("b:is_posix"))
syn match shHereString "<<<"	skipwhite	nextgroup=shCmdParenRegion
endif
syn match  shSetOption	"\s\zs[-+][a-zA-Z0-9]\+\>"	contained
syn match  shVariable	"\<\([bwglsav]:\)\=[a-zA-Z0-9.!@_%+,]*\ze="	nextgroup=shVarAssign
syn match  shVarAssign	"="		contained	nextgroup=shCmdParenRegion,shPattern,shDeref,shDerefSimple,shDoubleQuote,shExDoubleQuote,shSingleQuote,shExSingleQuote,shVar
syn match  shVar	contained	"\h\w*"
syn region shAtExpr	contained	start="@(" end=")" contains=@shIdList
if exists("b:is_bash")
syn match  shSet "^\s*set\ze\s\+$"
syn region shSetList oneline matchgroup=shSet start="\<\%(declare\|local\|export\)\>\ze[/a-zA-Z_]\@!" end="$"	matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+#\|="	contains=@shIdList
syn region shSetList oneline matchgroup=shSet start="\<\%(set\|unset\)\>[/a-zA-Z_]\@!" end="\ze[;|#)]\|$"		matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+="	contains=@shIdList nextgroup=shComment
elseif exists("b:is_kornshell") || exists("b:is_posix")
syn match  shSet "^\s*set\ze\s\+$"
syn region shSetList oneline matchgroup=shSet start="\<\(export\)\>\ze[/]\@!" end="$"		matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]"	contains=@shIdList
syn region shSetList oneline matchgroup=shSet start="\<\%(set\|unset\>\)\ze[/a-zA-Z_]\@!" end="\ze[;|#)]\|$"		matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]"	contains=@shIdList nextgroup=shComment
else
syn region shSetList oneline matchgroup=shSet start="\<\(set\|export\|unset\)\>\ze[/a-zA-Z_]\@!" end="\ze[;|#)]\|$"	matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]"	contains=@shIdList
endif
if !exists("b:is_posix")
syn keyword shFunctionKey function	skipwhite skipnl nextgroup=shFunctionTwo
endif
if exists("b:is_bash")
ShFoldFunctions syn region shFunctionOne	matchgroup=shFunction start="^\s*[A-Za-z_0-9:][-a-zA-Z_0-9:]*\s*()\_s*{"		end="}"	contains=@shFunctionList		 skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
ShFoldFunctions syn region shFunctionTwo	matchgroup=shFunction start="\%(do\)\@!\&\<[A-Za-z_0-9:][-a-zA-Z_0-9:]*\>\s*\%(()\)\=\_s*{"	end="}"	contains=shFunctionKey,@shFunctionList contained skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
ShFoldFunctions syn region shFunctionThree	matchgroup=shFunction start="^\s*[A-Za-z_0-9:][-a-zA-Z_0-9:]*\s*()\_s*("		end=")"	contains=@shFunctionList		 skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
ShFoldFunctions syn region shFunctionFour	matchgroup=shFunction start="\%(do\)\@!\&\<[A-Za-z_0-9:][-a-zA-Z_0-9:]*\>\s*\%(()\)\=\_s*)"	end=")"	contains=shFunctionKey,@shFunctionList contained skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
else
ShFoldFunctions syn region shFunctionOne	matchgroup=shFunction start="^\s*\h\w*\s*()\_s*{"			end="}"	contains=@shFunctionList		 skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
ShFoldFunctions syn region shFunctionTwo	matchgroup=shFunction start="\%(do\)\@!\&\<\h\w*\>\s*\%(()\)\=\_s*{"		end="}"	contains=shFunctionKey,@shFunctionList contained skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
ShFoldFunctions syn region shFunctionThree	matchgroup=shFunction start="^\s*\h\w*\s*()\_s*("			end=")"	contains=@shFunctionList		 skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
ShFoldFunctions syn region shFunctionFour	matchgroup=shFunction start="\%(do\)\@!\&\<\h\w*\>\s*\%(()\)\=\_s*("		end=")"	contains=shFunctionKey,@shFunctionList contained skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
endif
if !exists("g:sh_no_error")
syn match  shDerefWordError	"[^}$[~]"	contained
endif
syn match  shDerefSimple	"\$\%(\h\w*\|\d\)"	nextgroup=@shNoZSList
syn region shDeref	matchgroup=PreProc start="\${" end="}"	contains=@shDerefList,shDerefVarArray
syn match  shDerefSimple	"\$[-#*@!?]"	nextgroup=@shNoZSList
syn match  shDerefSimple	"\$\$"	nextgroup=@shNoZSList
syn match  shDerefSimple	"\${\d}"	nextgroup=@shNoZSList
if exists("b:is_bash") || exists("b:is_kornshell") || exists("b:is_posix")
syn region shDeref	matchgroup=PreProc start="\${##\=" end="}"	contains=@shDerefList	nextgroup=@shSpecialNoZS
syn region shDeref	matchgroup=PreProc start="\${\$\$" end="}"	contains=@shDerefList	nextgroup=@shSpecialNoZS
endif
if exists("b:is_kornshell") || exists("b:is_posix")
syn region shDeref	matchgroup=PreProc start="\${!" end="}"	contains=@shDerefVarArray
endif
if exists("b:is_bash")
syn region shDeref	matchgroup=PreProc start="\${!" end="\*\=}"	contains=@shDerefList,shDerefOff
syn match  shDerefVar	contained	"{\@<=!\h\w*"		nextgroup=@shDerefVarList
endif
if exists("b:is_kornshell")
syn match  shDerefVar	contained	"{\@<=!\h\w*[[:alnum:]_.]*"	nextgroup=@shDerefVarList
endif
syn match  shDerefSpecial	contained	"{\@<=[-*@?0]"		nextgroup=shDerefOp,shDerefOpError
syn match  shDerefSpecial	contained	"\({[#!]\)\@<=[[:alnum:]*@_]\+"	nextgroup=@shDerefVarList,shDerefOp
syn match  shDerefVar	contained	"{\@<=\h\w*"		nextgroup=@shDerefVarList
syn match  shDerefVar	contained	'\d'                            nextgroup=@shDerefVarList
if exists("b:is_kornshell") || exists("b:is_posix")
syn match  shDerefVar	contained	"{\@<=\h\w*[[:alnum:]_.]*"	nextgroup=@shDerefVarList
endif
syn region  shDerefVarArray   contained	matchgroup=shDeref start="\[" end="]"	contains=@shCommandSubList nextgroup=shDerefOp,shDerefOpError
syn cluster shDerefPatternList	contains=shDerefPattern,shDerefString
if !exists("g:sh_no_error")
syn match shDerefOpError	contained	":[[:punct:]]"
endif
syn match  shDerefOp	contained	":\=[-=?]"	nextgroup=@shDerefPatternList
syn match  shDerefOp	contained	":\=+"	nextgroup=@shDerefPatternList
if exists("b:is_bash") || exists("b:is_kornshell") || exists("b:is_posix")
syn match  shDerefOp	contained	"#\{1,2}"		nextgroup=@shDerefPatternList
syn match  shDerefOp	contained	"%\{1,2}"		nextgroup=@shDerefPatternList
syn match  shDerefPattern	contained	"[^{}]\+"		contains=shDeref,shDerefSimple,shDerefPattern,shDerefString,shCommandSub,shDerefEscape nextgroup=shDerefPattern
syn region shDerefPattern	contained	start="{" end="}"	contains=shDeref,shDerefSimple,shDerefString,shCommandSub nextgroup=shDerefPattern
syn match  shDerefEscape	contained	'\%(\\\\\)*\\.'
endif
if exists("b:is_bash")
syn match  shDerefOp	contained	"[,^]\{1,2}"	nextgroup=@shDerefPatternList
endif
syn region shDerefString	contained	matchgroup=shDerefDelim start=+\%(\\\)\@<!'+ end=+'+	contains=shStringSpecial
syn region shDerefString	contained	matchgroup=shDerefDelim start=+\%(\\\)\@<!"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial
syn match  shDerefString	contained	"\\["']"	nextgroup=shDerefPattern
if exists("b:is_bash")
syn region shDerefOff	contained	start=':[^-=?+]' end='\ze:'	end='\ze}'	contains=shDeref,shDerefSimple,shDerefEscape	nextgroup=shDerefLen,shDeref,shDerefSimple
syn region shDerefOff	contained	start=':\s-'	end='\ze:'	end='\ze}'	contains=shDeref,shDerefSimple,shDerefEscape	nextgroup=shDerefLen,shDeref,shDerefSimple
syn match  shDerefLen	contained	":[^}]\+"	contains=shDeref,shDerefSimple,shArithmetic
syn match  shDerefPPS	contained	'/\{1,2}'	nextgroup=shDerefPPSleft
syn region shDerefPPSleft	contained	start='.'	skip=@\%(\\\\\)*\\/@ matchgroup=shDerefOp	end='/' end='\ze}'	nextgroup=shDerefPPSright	contains=@shCommandSubList
syn region shDerefPPSright	contained	start='.'	skip=@\%(\\\\\)\+@		end='\ze}'				contains=@shPPSRightList
syn match  shDerefPSR	contained	'/#'	nextgroup=shDerefPSRleft,shDoubleQuote,shSingleQuote
syn region shDerefPSRleft	contained	start='[^"']'	skip=@\%(\\\\\)*\\/@ matchgroup=shDerefOp	end='/' end='\ze}'	nextgroup=shDerefPSRright
syn region shDerefPSRright	contained	start='.'	skip=@\%(\\\\\)\+@		end='\ze}'
endif
syn region shParen matchgroup=shArithRegion start='\$\@!(\%(\ze[^(]\|$\)' end=')' contains=@shArithParenList
syn keyword shStatement break cd chdir continue eval exec exit kill newgrp pwd read readonly return shift test trap ulimit umask wait
syn keyword shConditional contained elif else then
if !exists("g:sh_no_error")
syn keyword shCondError elif else then
endif
if exists("b:is_kornshell") || exists("b:is_posix")
syn keyword shStatement bg builtin disown enum export false fg getconf getopts hist jobs let printf sleep true unalias whence
syn keyword shStatement typeset skipwhite nextgroup=shSetOption
syn keyword shStatement autoload compound fc float functions hash history integer nameref nohup r redirect source stop suspend times type
if exists("b:is_posix")
syn keyword shStatement command
else
syn keyword shStatement time
endif
elseif exists("b:is_bash")
syn keyword shStatement bg builtin disown export false fg getopts jobs let printf sleep true unalias
syn keyword shStatement typeset nextgroup=shSetOption
syn keyword shStatement fc hash history source suspend times type
syn keyword shStatement bind builtin caller compopt declare dirs disown enable export help logout mapfile popd pushd readarray shopt source typeset
else
syn keyword shStatement login newgrp
endif
if !exists("g:sh_minlines")
let s:sh_minlines = 200
else
let s:sh_minlines= g:sh_minlines
endif
if !exists("g:sh_maxlines")
let s:sh_maxlines = 2*s:sh_minlines
if s:sh_maxlines < 25
let s:sh_maxlines= 25
endif
else
let s:sh_maxlines= g:sh_maxlines
endif
exec "syn sync minlines=" . s:sh_minlines . " maxlines=" . s:sh_maxlines
syn sync match shCaseEsacSync	grouphere	shCaseEsac	"\<case\>"
syn sync match shCaseEsacSync	groupthere	shCaseEsac	"\<esac\>"
syn sync match shDoSync	grouphere	shDo	"\<do\>"
syn sync match shDoSync	groupthere	shDo	"\<done\>"
syn sync match shForSync	grouphere	shFor	"\<for\>"
syn sync match shForSync	groupthere	shFor	"\<in\>"
syn sync match shIfSync	grouphere	shIf	"\<if\>"
syn sync match shIfSync	groupthere	shIf	"\<fi\>"
syn sync match shUntilSync	grouphere	shRepeat	"\<until\>"
syn sync match shWhileSync	grouphere	shRepeat	"\<while\>"
if !exists("skip_sh_syntax_inits")
hi def link shArithRegion	shShellVariables
hi def link shAstQuote	shDoubleQuote
hi def link shAtExpr	shSetList
hi def link shBkslshSnglQuote	shSingleQuote
hi def link shBkslshDblQuote	shDOubleQuote
hi def link shBeginHere	shRedir
hi def link shCaseBar	shConditional
hi def link shCaseCommandSub	shCommandSub
hi def link shCaseDoubleQuote	shDoubleQuote
hi def link shCaseIn	shConditional
hi def link shQuote	shOperator
hi def link shCaseSingleQuote	shSingleQuote
hi def link shCaseStart	shConditional
hi def link shCmdSubRegion	shShellVariables
hi def link shColon	shComment
hi def link shDerefOp	shOperator
hi def link shDerefPOL	shDerefOp
hi def link shDerefPPS	shDerefOp
hi def link shDerefPSR	shDerefOp
hi def link shDeref	shShellVariables
hi def link shDerefDelim	shOperator
hi def link shDerefSimple	shDeref
hi def link shDerefSpecial	shDeref
hi def link shDerefString	shDoubleQuote
hi def link shDerefVar	shDeref
hi def link shDoubleQuote	shString
hi def link shEcho	shString
hi def link shEchoDelim	shOperator
hi def link shEchoQuote	shString
hi def link shForPP	shLoop
hi def link shFunction	Function
hi def link shEmbeddedEcho	shString
hi def link shEscape	shCommandSub
hi def link shExDoubleQuote	shDoubleQuote
hi def link shExSingleQuote	shSingleQuote
hi def link shHereDoc	shString
hi def link shHereString	shRedir
hi def link shHerePayload	shHereDoc
hi def link shLoop	shStatement
hi def link shSpecialNxt	shSpecial
hi def link shNoQuote	shDoubleQuote
hi def link shOption	shCommandSub
hi def link shPattern	shString
hi def link shParen	shArithmetic
hi def link shPosnParm	shShellVariables
hi def link shQuickComment	shComment
hi def link shBQComment	shComment
hi def link shRange	shOperator
hi def link shRedir	shOperator
hi def link shSetListDelim	shOperator
hi def link shSetOption	shOption
hi def link shSingleQuote	shString
hi def link shSource	shOperator
hi def link shStringSpecial	shSpecial
hi def link shSpecialStart	shSpecial
hi def link shSubShRegion	shOperator
hi def link shTestOpr	shConditional
hi def link shTestPattern	shString
hi def link shTestDoubleQuote	shString
hi def link shTestSingleQuote	shString
hi def link shTouchCmd	shStatement
hi def link shVariable	shSetList
hi def link shWrapLineOperator	shOperator
if exists("b:is_bash")
hi def link bashAdminStatement	shStatement
hi def link bashSpecialVariables	shShellVariables
hi def link bashStatement		shStatement
hi def link shCharClass		shSpecial
hi def link shDerefOff		shDerefOp
hi def link shDerefLen		shDerefOff
endif
if exists("b:is_kornshell") || exists("b:is_posix")
hi def link kshSpecialVariables	shShellVariables
hi def link kshStatement		shStatement
endif
if !exists("g:sh_no_error")
hi def link shCaseError		Error
hi def link shCondError		Error
hi def link shCurlyError		Error
hi def link shDerefOpError		Error
hi def link shDerefWordError		Error
hi def link shDoError		Error
hi def link shEsacError		Error
hi def link shIfError		Error
hi def link shInError		Error
hi def link shParenError		Error
hi def link shTestError		Error
if exists("b:is_kornshell") || exists("b:is_posix")
hi def link shDTestError		Error
endif
endif
hi def link shArithmetic		Special
hi def link shCharClass		Identifier
hi def link shSnglCase		Statement
hi def link shCommandSub		Special
hi def link shCommandSubBQ		shCommandSub
hi def link shComment		Comment
hi def link shConditional		Conditional
hi def link shCtrlSeq		Special
hi def link shExprRegion		Delimiter
hi def link shFunctionKey		Function
hi def link shFunctionName		Function
hi def link shNumber		Number
hi def link shOperator		Operator
hi def link shRepeat		Repeat
hi def link shSet		Statement
hi def link shSetList		Identifier
hi def link shShellVariables		PreProc
hi def link shSpecial		Special
hi def link shSpecialDQ		Special
hi def link shSpecialSQ		Special
hi def link shSpecialNoZS		shSpecial
hi def link shStatement		Statement
hi def link shString		String
hi def link shTodo		Todo
hi def link shAlias		Identifier
hi def link shHereDoc01		shRedir
hi def link shHereDoc02		shRedir
hi def link shHereDoc03		shRedir
hi def link shHereDoc04		shRedir
hi def link shHereDoc05		shRedir
hi def link shHereDoc06		shRedir
hi def link shHereDoc07		shRedir
hi def link shHereDoc08		shRedir
hi def link shHereDoc09		shRedir
hi def link shHereDoc10		shRedir
hi def link shHereDoc11		shRedir
hi def link shHereDoc12		shRedir
hi def link shHereDoc13		shRedir
hi def link shHereDoc14		shRedir
hi def link shHereDoc15		shRedir
endif
delc ShFoldFunctions
delc ShFoldHereDoc
delc ShFoldIfDoFor
if exists("b:is_bash")
let b:current_syntax = "bash"
elseif exists("b:is_kornshell")
let b:current_syntax = "ksh"
elseif exists("b:is_posix")
let b:current_syntax = "posix"
else
let b:current_syntax = "sh"
endif