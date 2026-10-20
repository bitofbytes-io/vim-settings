set nocompatible
let &runtimepath = $HOME . '/.vim,' . $VIMRUNTIME
if $TRUECOLOR_OVERRIDE !=# ''
  let g:vim_settings_truecolor = str2nr($TRUECOLOR_OVERRIDE)
endif
if has('termguicolors')
  let &termguicolors = str2nr($INITIAL_TRUECOLOR)
endif
execute 'source ' . fnameescape($CONFIG_ROOT . '/.vimrc')
call assert_equal('', v:errmsg)
call assert_equal(4, &tabstop)
call assert_equal(4, &softtabstop)
call assert_equal(4, &shiftwidth)
call assert_equal(1, &expandtab)
call assert_equal(0, &smartindent)
call assert_equal(1, &ignorecase)
call assert_equal(1, &smartcase)
call assert_equal(1, &number)
call assert_equal(100, &textwidth)
call assert_equal($EXPECTED_THEME, g:colors_name)
if has('termguicolors')
  call assert_equal(str2nr($EXPECTED_TRUECOLOR), &termguicolors, $TRUECOLOR_CASE)
endif
edit example.py
call assert_equal('python', &filetype)
call assert_true(exists('b:did_ftplugin'))
call assert_true(exists('b:did_indent'))
edit Makefile
call assert_equal('make', &filetype)
call assert_equal(0, &l:expandtab)
call setline(1, ['all:', ''])
call cursor(2, 1)
execute "normal! i\<Tab>echo ready\<Esc>"
call assert_equal("\techo ready", getline(2), 'Make recipes must begin with a literal tab')
if len(v:errors)
  call writefile(v:errors, $TEST_ERRORS)
  cquit
endif
qa!
