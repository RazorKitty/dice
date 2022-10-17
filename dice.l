delim   [\t\r]
ws      {delim}+
digit   [0-9]
number  {digit}+

%%

{ws}     ; /* Do Nothing */
\n       return(NEWLINE_T);
"+"      return(PLUS_T);
"*"      return(TIMES_T);
"-"      return(MINUS_T);
"/"      return(DIVIDE_T);
"("      return(BRA_T);
")"      return(KET_T);
"d"      return(DICE_T);
{number} {
        yylval.iVal = atoi(yytext);
        return(NUMBER_T);
    }
