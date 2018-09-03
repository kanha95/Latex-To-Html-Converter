%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "headerFile.h"


int test=1;
int ruletwo=0;
int yywrap(void);
int yylineno;
int yylex();

FILE *ff;

%}

%union{struct ast *a;
       char *p;}          
%token START BEGINDOC ENDDOC SECTION TEXT SUBSECTION PARAGRAPH SUBPARA BOLDTEXT ITEM LIST LISTEND ULIST ULISTEND GRAPHICS BFIG IFIG CAP EFIG BTAB ETAB HLINE DS AMP ITATEXT UNDERLINE LABEL REF MMODE EOL
%start ST
%type <a> CONTENT S SS T P PP L L1 G TC B LATEX LT G1 B1
%type <p> TEXT SECTION SUBSECTION PARAGRAPH SUBPARA BOLDTEXT ITEM LIST LISTEND ULIST ULISTEND IFIG CAP START ENDDOC ITATEXT UNDERLINE REF LABEL MMODE EOL
%%


ST: LT {ff=fopen("myweb.html", "w"); 
                              //  printf("%s",eval($3));
                               
                               fprintf(ff,"%s",eval($1)); 
                                fclose(ff);}


;
LT: LATEX ENDDOC{ $$=newast('S',$1,newstr($2));}

;
LATEX: START BEGINDOC CONTENT {$$=newast('S',newstr($1),$3); 
                              }

| START GRAPHICS BEGINDOC CONTENT { $$=newast('S',newstr($1),$4); 
                              }
;
CONTENT:S {}
|T {}
|P {}
|L {}
|G {}
|B {}
;

S:SECTION T {  $$=newast('A',newstr($1),$2);} 
|SECTION SS { $$=newast('A',newstr($1),$2);}
| SECTION S { $$=newast('A',newstr($1),$2); } 
| SECTION P { $$=newast('A',newstr($1),$2); } 
| SECTION L { $$=newast('A',newstr($1),$2); } 
| SECTION G {  $$=newast('A',newstr($1),$2); } 
| SECTION B { $$=newast('A',newstr($1),$2); } 
;

SS: SUBSECTION T { $$=newast('A',newstr($1),$2);}

| SUBSECTION P {$$=newast('A',newstr($1),$2);}

| SUBSECTION L {$$=newast('A',newstr($1),$2);}

| SUBSECTION G {$$=newast('A',newstr($1),$2);}

| SUBSECTION B {$$=newast('A',newstr($1),$2);}

| SUBSECTION SS {$$=newast('A',newstr($1),$2); }
;

P:PARAGRAPH PP{ strcat($1,"<br>"); $$=newast('S',newstr($1),$2);} 
| PARAGRAPH T{ $$=newast('A',newstr($1),$2);} 
| PARAGRAPH L{strcat($1,"<br>"); $$=newast('S',newstr($1),$2);} 
| PARAGRAPH G{strcat($1,"<br>"); $$=newast('S',newstr($1),$2);} 
| PARAGRAPH B{strcat($1,"<br>"); $$=newast('S',newstr($1),$2);} 
|PARAGRAPH P {strcat($1,"<br>"); $$=newast('S',newstr($1),$2);}
;

PP:SUBPARA T{ $$=newast('A',newstr($1),$2);}
| SUBPARA L{strcat($1,"<br>"); $$=newast('S',newstr($1),$2);}
|SUBPARA PP{ strcat($1,"<br>"); $$=newast('S',newstr($1),$2);}
|SUBPARA B{ strcat($1,"<br>"); $$=newast('S',newstr($1),$2);}
|SUBPARA G{ strcat($1,"<br>"); $$=newast('S',newstr($1),$2);}
|SUBPARA S{ strcat($1,"<br>"); $$=newast('S',newstr($1),$2);}
;

T: TEXT SS {strcat($1,"<br>"); $$=newast('S',newstr($1),$2);}
|TEXT { strcat($1,"<br>"); $$=newstr($1);}
|TEXT T {$$=newast('S',newstr($1),$2); }
| TEXT S {strcat($1,"<br>"); $$=newast('S',newstr($1),$2); }
| TEXT B {strcat($1,"<br>"); $$=newast('S',newstr($1),$2); }
| TEXT L {strcat($1,"<br>"); $$=newast('S',newstr($1),$2); }
|  TEXT P {strcat($1,"<br><br>"); $$=newast('S',newstr($1),$2); }
| TEXT PP {strcat($1,"<br><br>"); $$=newast('S',newstr($1),$2); }
| TEXT G {strcat($1,"<br>"); $$=newast('S',newstr($1),$2); }
| BOLDTEXT T {char *p=(char *)malloc(strlen($1)+17); strcpy(p,"<strong>"); strcat(p,$1); strcat(p,"</strong>"); $$=newast('S',newstr(p),$2);}
| ITATEXT T {char *p=(char *)malloc(strlen($1)+10); strcpy(p,"<i>"); strcat(p,$1); strcat(p,"</i>"); $$=newast('S',newstr(p),$2);}
| UNDERLINE T {char *p=(char *)malloc(strlen($1)+10); strcpy(p,"<u>"); strcat(p,$1); strcat(p,"</u>"); $$=newast('S',newstr(p),$2);}
| LABEL T { $$=newast('S',newstr(""),$2);}
| REF T { $$=newast('S',newstr($1),$2);}
| MMODE T { $$=newast('S',newstr($1),$2);}
;

/*
L:  {} 
|LIST L1 LISTEND L{$$=newast('P',newstr($1),$2);}
| ULIST L1 ULISTEND L{$$=newast('Q',newstr($1),$2);}
;


L1: L {$$=$1;}
| ITEM L1 {char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li>"); $$=newast('S',newstr(p),$2);}
| ITEM {char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li>"); $$=newstr(p);}
;
*/


L: LIST L1 {$$=newast('S',newstr($1),$2);}
| ULIST L1 {$$=newast('S',newstr($1),$2);}
;


L1: LISTEND {$$=newstr($1);}
|  ULISTEND {$$=newstr($1);}
|  LISTEND L1 {$$=newast('S',newstr("</ol>"),$2);}
|  ULISTEND L1{$$=newast('S',newstr("</ul>"),$2);}
|  LISTEND L {$$=newast('S',newstr("</ol>"),$2);}
|  ULISTEND L{$$=newast('S',newstr("</ul>"),$2);}
|  ITEM LISTEND SS{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ol>"); $$=newast('S',newstr(p),$3); }
|  ITEM ULISTEND SS{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ul>"); $$=newast('S',newstr(p),$3); }
|  ITEM LISTEND S{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ol>"); $$=newast('S',newstr(p),$3); }
|  ITEM ULISTEND S{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ul>"); $$=newast('S',newstr(p),$3); }
|  ITEM LISTEND P{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ol>"); $$=newast('S',newstr(p),$3); }
|  ITEM ULISTEND PP{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ul>"); $$=newast('S',newstr(p),$3); }
|  ITEM LISTEND T{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ol>"); $$=newast('S',newstr(p),$3); }
|  ITEM ULISTEND T{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ul>"); $$=newast('S',newstr(p),$3); }
|  ITEM LISTEND G{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ol>"); $$=newast('S',newstr(p),$3); }
|  ITEM ULISTEND G{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ul>"); $$=newast('S',newstr(p),$3); }
|  ITEM LISTEND B{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ol>"); $$=newast('S',newstr(p),$3); }
|  ITEM ULISTEND B{char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<li>"); strcat(p,$1); strcat(p,"</li></ul>"); $$=newast('S',newstr(p),$3); }
|  ITEM L1{char *p=(char *)malloc(strlen($1)+9); strcat(p,"<li>"); strcat(p,$1); strcat(p,"</li>");$$=newast('S',newstr(p),$2);}
|  ITEM L {char *p=(char *)malloc(strlen($1)+9); strcat(p,"<li>"); strcat(p,$1); strcat(p,"</li>");$$=newast('S',newstr(p),$2);}
;


G: G1 {$$=$1;}
| G1 CONTENT {$$=newast('S',$1,$2);}

G1: BFIG IFIG CAP EFIG{ char *p=(char *)malloc(54+12+strlen($2)+strlen($3)); strcat(p,"<figure><img width=\"100%\" src=\""); strcat(p,$2); strcat(p,"\">"); 
strcat(p,"<caption>"); strcat(p,$3); strcat(p,"</caption></figure>"); $$=newstr(p); }
;

B: B1 {$$=$1;}
| B1 CONTENT {$$=newast('S',$1,$2);}

B1: BTAB HLINE TC {char *p=(char *)malloc(50); strcpy(p,"<table border=\"1\" cellpadding=\"4\" cellspacing=\"0\"><tr>"); $$=newast('S',newstr(p),$3);  }
;

TC: TEXT AMP TC {char *p=(char *)malloc(strlen($1)+9); strcpy(p,"<td>"); strcat(p,$1); strcat(p,"</td>"); $$=newast('S',newstr(p),$3); }
| TEXT DS HLINE TC {char *p=(char *)malloc(strlen($1)+9+9); strcpy(p,"<td>"); strcat(p,$1); strcat(p,"</td></tr><tr>"); $$=newast('S',newstr(p),$4);  }
| TEXT DS HLINE ETAB {char *p=(char *)malloc(strlen($1)+9+13); strcpy(p,"<td>"); strcat(p,$1); strcat(p,"</td></tr></table>"); $$=newstr(p); }
;

 
%%

 void itoa(int n, char s[])
 {
     int i;
     int sign=n;
 
     if (sign < 0) n = -n;          
     
     i = 0;
     do {      
         s[i++] = n % 10 + '0';   
     } while ((n /= 10) > 0);     
     
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 }

 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }


struct ast *newast(char nodetype, struct ast *l, struct ast *r)
{

struct ast *a = malloc(sizeof(struct ast));

//printf("y");
if(!a) {
yyerror("out of space");
exit(0);
}

a->nodetype = nodetype;

a->left = l;
a->right = r;

return a;

}


struct ast *newstr(char *d)
{
struct str *g = malloc(sizeof(struct str));

if(!g) {
yyerror("out of space");
exit(0);
}

g->nodetype = 'K';
g->value = d;


struct ast *uu = (struct ast *)g;
//(*uu).left=NULL;
//printf("%s",((*uu).left==NULL)?"Y":"N");
return uu;

}

char* eval(struct ast *a){

if(a->nodetype == 'K'){
//printf("%s \n",(((struct str *)a) -> value));

char *yy=(char *)malloc(140000);
strcpy(yy,(((struct str *)a) -> value));
a=NULL;
free(a);
return yy;
}
else if(a->nodetype =='P'){
char *p= (char *) malloc (140000);
strcpy(p,"<ol>");
strcat(p,eval(a->right));
a=NULL;
free(a);
//printf("%s\n",strcat(p,"</ol>"));
return strcat(p,"</ol>");
}
else if(a->nodetype =='A'){

char *yy=(char *)malloc(140000);
strcpy(yy,eval(a->left));
char *yyy=(char *)malloc(140000);
strcpy(yyy,eval(a->right));
a=NULL;
free(a);
 
strcat(yy,yyy);
//printf("%s",yy);
return yy;
}
else if(a->nodetype =='Q'){
char *p= (char *) malloc (140000);
strcpy(p,"<ul>");
strcat(p,eval(a->right));
//printf("%s\n",strcat(p,"</ol>"));
return strcat(p,"</ul>");
}
else{

if((a->left)==NULL && (a->right)==NULL) return NULL;
else if ((a->left)==NULL && (a->right)!=NULL){
char *yy=(char *)malloc(140000);
strcpy(yy,eval(a->left));
a=NULL;
free(a); 
return yy;
}
else if ((a->left)!=NULL && (a->right)==NULL){
char *yy=(char *)malloc(140000);
strcpy(yy,eval(a->left));
a=NULL;
free(a); 
 return eval(a->left);
}
else {
char *yy=(char *)malloc(140000);
strcpy(yy,eval(a->left));
char *yyy=(char *)malloc(140000);
strcpy(yyy,eval(a->right));
a=NULL;
free(a); 
return strcat(yy,yyy); 
}
}


}


int main(int argc, char** argv)
{
extern FILE *yyin;

if(argc > 1) {
if(!(yyin = fopen(argv[1], "r"))) {
perror(argv[1]);
return (1);
}
}
 yyparse();
 return 0;
}
int yywrap(void)
{
 return 1;
}
void yyerror(char* msg, ...)
{
  fprintf (stderr, "%s\n", msg);
 printf("%d: error: ", yylineno);
}

