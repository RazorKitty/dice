build:
	flex dice.l
	bison dice.y
	gcc -o dice dice.tab.c dice.c -lfl
clean:
	rm -f lex.yy.c dice.tab.c dice
