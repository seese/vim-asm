if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=AsmIndent()
setlocal indentkeys=o,O,*<Return>,0[,],0;,0#,=,!^F

function! AsmIndent()
	"comment
	let l:attr = synIDattr(synID(v:lnum, 1, 1), 'name')
	if l:attr == 'asmComment'
		return indent(v:lnum)
	endif

	let l:cline = getline(v:lnum)

	"directive
	if l:cline =~ '^\s*\.[A-Za-z][0-9A-Za-z-_]*'
		if l:cline =~ '^\s*\.global.*'
			return 0
		elseif l:cline =~ '^\s*\.data.*'
			return 0
		elseif l:cline =~ '^\s*\.text.*'
			return 0
		elseif l:cline =~ '^\s*\.balign.*'
			return 0
		else
			return &sw
		endif
	"label
	elseif l:cline =~ '^\s*[A-Za-z][0-9A-Za-z-_]*:'
		return 0
	"statement
	elseif l:cline =~ '^\s*[A-Za-z][0-9A-Za-z-_]*'
		return &sw
	endif

	return indent(v:lnum)
endfunction
