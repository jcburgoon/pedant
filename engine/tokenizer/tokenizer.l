%{
#include <assert.h>
#include <string.h>

#include "tokenizer.h"

static int make_token(tok_id_t);

static fpos_t position = 0;
static bool emit_comments = false;
static tok_t *yylval = NULL;

extern FILE *yyin;
extern int yylex(void);
%}

%option noyywrap
%option nounput
%option noinput

ident			[_[:alpha:]][_[:alnum:]]*

decdigits		[[:digit:]]+
octdigits		[0-7]+
hexdigits		[[:xdigit:]]+

data			(\\.|[^'\\])*
string			[^\"]*

comment			#[^\r\n]*
whitespace		[[:space:]]+

%%

"break"			return make_token(BREAK);
"continue"		return make_token(CONTINUE);
"else"			return make_token(ELSE);
"export"		return make_token(EXPORT);
"for"			return make_token(FOR);
"foreach"		return make_token(FOREACH);
"function"		return make_token(FUNCTION);
"global_var"		return make_token(GLOBAL);
"if"			return make_token(IF);
"import"		return make_token(IMPORT);
"include"		return make_token(INCLUDE);
"local_var"		return make_token(LOCAL);
"repeat"		return make_token(REPEAT);
"return"		return make_token(RETURN);
"until"			return make_token(UNTIL);
"x"			return make_token(REP);
"while"			return make_token(WHILE);

"FALSE"			return make_token(FALSE);
"NULL"			return make_token(UNDEF);
"TRUE"			return make_token(TRUE);

"><"			return make_token(SUBSTR_EQ);
">!<"			return make_token(SUBSTR_NE);

"=~"			return make_token(REGEX_EQ);
"!~"			return make_token(REGEX_NE);

"=="			return make_token(CMP_EQ);
"!="			return make_token(CMP_NE);
"<="			return make_token(CMP_LE);
">="			return make_token(CMP_GE);

"="			return make_token(ASS_EQ);
"+="			return make_token(ADD_EQ);
"-="			return make_token(SUB_EQ);
"*="			return make_token(MUL_EQ);
"/="			return make_token(DIV_EQ);
"%="			return make_token(MOD_EQ);
">>="			return make_token(SRL_EQ);
">>>="			return make_token(SRA_EQ);
"<<="			return make_token(SLL_EQ);

"||"			return make_token(OR);
"&&"			return make_token(AND);
"!"			return make_token(NOT);

"|"			return make_token(BIT_OR);
"^"			return make_token(BIT_XOR);
"&"			return make_token(BIT_AND);
">>>"			return make_token(BIT_SRA);
">>"			return make_token(BIT_SRL);
"<<"			return make_token(BIT_SLL);

"<"			return make_token(CMP_LT);
">"			return make_token(CMP_GT);

"++"			return make_token(INCR);
"--"			return make_token(DECR);

"**"			return make_token(EXP);

"+"			return make_token(ADD);
"-"			return make_token(SUB);
"*"			return make_token(MUL);
"/"			return make_token(DIV);
"%"			return make_token(MOD);

"~"			return make_token(BIT_NOT);

"."			return make_token(PERIOD);
","			return make_token(COMMA);
":"			return make_token(COLON);
";"			return make_token(SEMICOLON);
"("			return make_token(LPAREN);
")"			return make_token(RPAREN);
"["			return make_token(LBRACK);
"]"			return make_token(RBRACK);
"{"			return make_token(LBRACE);
"}"			return make_token(RBRACE);
"@"			return make_token(ATSIGN);

{ident}			return make_token(IDENT);

0[xX]{hexdigits}	return make_token(INTEGER);
0{octdigits}		return make_token(INTEGER);
{decdigits}		return make_token(INTEGER);

'{data}'		return make_token(DATA);
\"{string}\"		return make_token(STRING);

{comment}		if (emit_comments) return make_token(COMMENT);

{whitespace}		/* Ignored. */

%%

/******************************************************************************
 * Private Functions
 ******************************************************************************/

static int make_token(tok_id_t type)
{
	// Ensure that someone has consumed the previous token.
	assert(yylval == NULL);

	// Produce a new token.
	size_t len = strlen(yytext);
	yylval = token_new(type, position, len);
	position += len;

	return type;
}

static tok_t *read_token(void)
{
	// Ensure that nobody has consumed the previous token.
	assert(yylval != NULL);

	// Consume the token.
	tok_t *tok = yylval;
	yylval = NULL;

	return tok;
}

/******************************************************************************
 * Public Functions
 ******************************************************************************/

void tokenizer_comments(bool choice)
{
	emit_comments = choice;
}

tok_t *tokenizer_get_one(void)
{
	tok_id_t id = yylex();
	if (id <= 0)
		return NULL;

	return read_token();
}

tok_t *tokenizer_get_all(void)
{
	// XXX-MAK: Fill in later.
	return NULL;
}

void tokenizer_load(FILE *src)
{
	assert(src != NULL);

	yyin = src;
}

void tokenizer_unload(void)
{
	assert(yyin != NULL);

	yyin = NULL;
}