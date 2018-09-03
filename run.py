import os
os.system("bison -d bisonfile1.y")
os.system("flex bisonfile1.l")
os.system("gcc -o bisonfile lex.yy.c bisonfile1.tab.c")
os.system("./bisonfile tut1.tex")
