%{

/* A Named constant denoting a null value in the tree */
#define NOTHING -1

/* Import the standard C I/O libraries */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/* Define the Object Structure for a tree node to store
   the compiled result */

struct treeNode
{
    int  item;
    int  nodeIdentifier;
    struct treeNode *first;
    struct treeNode *second;
};

typedef struct treeNode TREE_NODE;
typedef TREE_NODE       *BINARY_TREE;

/* define method templates for functions that build and use trees */
void yyerror(char *s);
int yylex(void);
int evaluate(BINARY_TREE);
BINARY_TREE create_node(int,int,BINARY_TREE,BINARY_TREE);

%}

%start lines

%union
{
    int iVal;
    BINARY_TREE tVal;
}

%token<iVal> NUMBER_T PLUS_T MINUS_T TIMES_T DIVIDE_T BRA_T KET_T NEWLINE_T EXPR_T TERM_T DICE_T
%type<tVal>  line expr term factor

%%

lines   : line lines
        | line
        ;
line    : expr NEWLINE_T
            {
                srand(time(NULL));
                BINARY_TREE ParseTree; int result;
                ParseTree = create_node(NOTHING, NEWLINE_T, $1, NULL);
                result = evaluate(ParseTree);
                printf("result : %d\n", result);
            }
        ;
expr    : term PLUS_T expr
            {
                $$ = create_node(NOTHING, PLUS_T, $1, $3);
            }
        | term MINUS_T expr
            {
                $$ = create_node(NOTHING, MINUS_T, $1, $3);
            }
        | term
            {
                $$ = create_node(NOTHING, EXPR_T, $1, NULL);
            }
        ;
term    : factor DIVIDE_T term
            {
                $$ = create_node(NOTHING, DIVIDE_T, $1, $3);
            }
        | factor TIMES_T term
            {
                $$ = create_node(NOTHING, TIMES_T, $1, $3);
            }
        | factor DICE_T term
            {
                $$ = create_node(NOTHING, DICE_T, $1, $3);
            }
        | factor
            {
                $$ = create_node(NOTHING, TERM_T, $1, NULL);
            }
        ;
factor  : BRA_T expr KET_T
            {
                $$ = create_node(NOTHING, BRA_T, $2, NULL);
            }
        | NUMBER_T
            {
                $$ = create_node($1, NUMBER_T, NULL, NULL);
            }
        | MINUS_T NUMBER_T
            {
                $$ = create_node(-$1, NUMBER_T, NULL, NULL);
            }
        ;

%%

BINARY_TREE create_node(int ival,
                        int case_identifier,
                        BINARY_TREE p1,
                        BINARY_TREE p2)
{
    BINARY_TREE t;
    t = (BINARY_TREE)malloc(sizeof(TREE_NODE));
    t->item = ival;
    t->nodeIdentifier = case_identifier;
    t->first = p1;
    t->second = p2;
    return (t);
}

int evaluate(BINARY_TREE t)
{
    int lhs, rhs, res;
    if (t != NULL)
    {
	switch(t->nodeIdentifier)
        {
            case(NEWLINE_T):
                return(evaluate(t->first));
            case(PLUS_T):
                lhs = evaluate(t->first);
                rhs = evaluate(t->second);
                res = lhs + rhs;
                printf("(%d + %d = %d) ", lhs, rhs, res);
                return(res);
            case(MINUS_T):
                lhs = evaluate(t->first);
                rhs = evaluate(t->second);
                res = lhs - rhs;
                printf("(%d - %d = %d) ", lhs, rhs, res);
                return(res);
            case(EXPR_T):
                return(evaluate(t->first));
            case(TIMES_T):
                lhs = evaluate(t->first);
                rhs = evaluate(t->second);
                res = lhs * rhs;
                printf("(%d * %d = %d) ", lhs, rhs, res);
                return(res);
            case(DIVIDE_T):
                lhs = evaluate(t->first);
                rhs = evaluate(t->second);
                res = lhs / rhs;
                printf("(%d / %d = %d) ", lhs, rhs, res);
                return(res);
            case(TERM_T):
                return(evaluate(t->first));
            case(BRA_T):
                return(evaluate(t->first));
            case(NUMBER_T):
                return(t->item);
            case(DICE_T):
                lhs = evaluate(t->first);
                rhs = evaluate(t->second);
                res = 0;
                for (int i = 0; i < lhs; ++i)
                    res += rand() % rhs + 1;
                printf("(%d d %d = %d) ", lhs, rhs, res);
                return(res);
        }
    }
}

#include "lex.yy.c"
