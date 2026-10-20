set nocompatible
let &runtimepath = $HOME . '/.vim,' . $VIMRUNTIME
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
  call assert_equal(1, &termguicolors)
endif
edit example.py
call assert_equal('python', &filetype)
call assert_true(exists('b:did_ftplugin'))
call assert_true(exists('b:did_indent'))
if len(v:errors)
  call writefile(v:errors, $TEST_ERRORS)
  cquit
endif
qa!
