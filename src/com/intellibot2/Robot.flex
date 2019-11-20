package com.intellibot2;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;
import com.intellibot2.psi.RobotTypes;
import com.intellij.psi.TokenType;
import java.util.regex.Pattern;

%%

%class RobotLexer
%implements FlexLexer
%function advance
%type IElementType
%eof{  return;
%eof}
%{
    private static final Pattern VARIABLE_DECL_PATTERN = Pattern.compile("\\$\\{[^}]+}");
    private int previousState;
%}

CRLF=\R
CELL_SEP=\ [ \t]+ | \t[ \t]*
NON_WHITE=[^ \t\r\n]
NON_WHITE_STAR=[^ \t\r\n\*]
CELLN={NON_WHITE}+(\ {NON_WHITE}+)*
CELL0=\ ?{NON_WHITE_STAR}+(\ {NON_WHITE}+)*
ELLIPSIS=\.\.\.
COMMENT=\#.*
TABLE_HEAD_PREFIX=\ ?\*+\ ?
TABLE_HEAD_POSTFIX=\ ?\**

%state WAIT_SETTINGS_HEAD_END WAIT_VARIABLES_HEAD_END WAIT_TESTCASES_HEAD_END WAIT_KEYWORDS_HEAD_END
%state SETTING_ROW VARIABLE_ROW TESTCASE_ROW KEYWORD_ROW
%state WAIT_SETTING_ARGUMENT WAIT_VARIABLE_ARGUMENT
%state WAIT_ERROR_HEAD_END WAIT_ERROR_TO_EOL ERROR_TABLE

%%

^{TABLE_HEAD_PREFIX}Settings{TABLE_HEAD_POSTFIX}    / ({CELL_SEP}|{CRLF})  {yybegin(WAIT_SETTINGS_HEAD_END); return RobotTypes.SETTINGS_HEADER;}
^{TABLE_HEAD_PREFIX}Variables{TABLE_HEAD_POSTFIX}   / ({CELL_SEP}|{CRLF})  {yybegin(WAIT_VARIABLES_HEAD_END); return RobotTypes.VARIABLES_HEADER;}
^{TABLE_HEAD_PREFIX}Test\ Cases{TABLE_HEAD_POSTFIX} / ({CELL_SEP}|{CRLF})  {yybegin(WAIT_TESTCASES_HEAD_END); return RobotTypes.TESTCASE_HEADER;}
^{TABLE_HEAD_PREFIX}Keywords{TABLE_HEAD_POSTFIX}    / ({CELL_SEP}|{CRLF})  {yybegin(WAIT_KEYWORDS_HEAD_END); return RobotTypes.KEYWORDS_HEADER;}
^{TABLE_HEAD_PREFIX}.                                                      {yybegin(WAIT_ERROR_HEAD_END); return TokenType.ERROR_ELEMENT;}

<WAIT_ERROR_HEAD_END>.*{CRLF}?  {yybegin(ERROR_TABLE); return TokenType.ERROR_ELEMENT;}
<ERROR_TABLE>^\ ?[^*].*{CRLF}?  {return TokenType.ERROR_ELEMENT;}

<WAIT_SETTINGS_HEAD_END, WAIT_VARIABLES_HEAD_END, WAIT_TESTCASES_HEAD_END, WAIT_KEYWORDS_HEAD_END> {
  {NON_WHITE}.*  {return RobotTypes.COMMENT;}
}
<WAIT_SETTINGS_HEAD_END>   {CRLF}  {yybegin(SETTING_ROW); return RobotTypes.NEWLINE; }
<WAIT_VARIABLES_HEAD_END>  {CRLF}  {yybegin(VARIABLE_ROW); return RobotTypes.NEWLINE; }
<WAIT_TESTCASES_HEAD_END>  {CRLF}  {yybegin(TESTCASE_ROW); return RobotTypes.NEWLINE; }
<WAIT_KEYWORDS_HEAD_END>   {CRLF}  {yybegin(KEYWORD_ROW); return RobotTypes.NEWLINE; }

<SETTING_ROW>^{CELL0}     {yybegin(WAIT_SETTING_ARGUMENT); return RobotTypes.SETTING;}
<VARIABLE_ROW>^{CELL0}    {
          if (VARIABLE_DECL_PATTERN.matcher(yytext()).matches()) {
              yybegin(WAIT_VARIABLE_ARGUMENT);
              return RobotTypes.VARIABLE;
          } else {
              previousState=yystate();
              yybegin(WAIT_ERROR_TO_EOL);
          }
      }
//<TESTCASE_ROW>^{CELL0}    {yybegin(WAIT_ARGUMENT); return RobotTypes.TESTCASE;}
//<KEYWORD_ROW>^{CELL0}     {yybegin(WAIT_ARGUMENT); return RobotTypes.KEYWORD;}

<WAIT_SETTING_ARGUMENT, WAIT_VARIABLE_ARGUMENT> {
  {COMMENT}   {return RobotTypes.COMMENT;}
  {CELLN}     {return RobotTypes.ARGUMENT;}
  {CRLF}{CELL_SEP}?{ELLIPSIS}{CELL_SEP}   {return TokenType.WHITE_SPACE;}
}

<WAIT_SETTING_ARGUMENT>  {CRLF} {yybegin(SETTING_ROW); return TokenType.WHITE_SPACE;}
<WAIT_VARIABLE_ARGUMENT> {CRLF} {yybegin(VARIABLE_ROW); return TokenType.WHITE_SPACE;}

<WAIT_ERROR_TO_EOL>.*{CRLF}?  {yybegin(previousState); return RobotTypes.ERROR;}

{CELL_SEP}  {return TokenType.WHITE_SPACE;}
[^]  {return TokenType.ERROR_ELEMENT;}

