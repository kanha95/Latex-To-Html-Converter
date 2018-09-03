%{
#include <stdlib.h>
#include "bisonfile1.tab.h"

void yyerror(char*,...);

char figcount[2]="1";
char scount[2]="1";

char sscount[2]="1";
char store[10][30];
int bb=0;
%}

%%


"$$"[0-9 A-Za-z^_{}+-]+"$$" {

char math[100],stack[30];
int i=2,j=0,top=-1;
int h=0;
for(;i<yyleng-2;i++){
if(yytext[i]=='{') {h=1; continue;}
else if(yytext[i]=='^'){ h=0; math[j++]='<'; math[j++]='s'; math[j++]='u'; math[j++]='p'; math[j++]='>'; stack[++top]='^';}
else if(yytext[i]=='_') { h=0; math[j++]='<'; math[j++]='s'; math[j++]='u'; math[j++]='b'; math[j++]='>'; stack[++top]='_';}
else if(yytext[i]=='}') {  math[j++]='<'; math[j++]='/'; math[j++]='s'; math[j++]='u'; math[j++]=((stack[top--]=='^')?'p':'b'); math[j++]='>';}
else if(!h && (stack[top]=='^' || stack[top]=='_')) { math[j++]=yytext[i]; math[j++]='<'; math[j++]='/'; math[j++]='s'; math[j++]='u'; math[j++]=((stack[top--]=='^')?'p':'b'); math[j++]='>'; }
else math[j++]=yytext[i];
}
math[j]='\0';
  yylval.p = (char *) malloc(yyleng+100);

strcpy(yylval.p,math);

return MMODE;


}



"\\documentclass{article}"	{
				  yylval.p=(char *)malloc(100);
strcpy(yylval.p,"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"mystyle.css\"></head><body><div>");
				 return START;
				}

"\\begin{document}" 		{
				 
				 return BEGINDOC;
				}

"\\section"[{][a-z A-Z]+[}]	{ //printf("%s",yytext);
                                  yylval.p = (char *) malloc(yyleng+11);
                                 
                                  char *ch;int i;
                                  
                                  sscount[0]='1';
                                 
                                    
                                     ch = (char *) malloc(yyleng-10);

                                     for(i=9;i<yyleng-1;i++) ch[i-9]=yytext[i]; 
                                     ch[i-9]='\0'; 
                                  strcpy(yylval.p,"<h3>");
                                  strcat(yylval.p,scount);
                                 strcat(yylval.p,"&nbsp;&nbsp;&nbsp;");
                                 strcat(yylval.p,ch);
                                 strcat(yylval.p,"</h3>");
                                 scount[0]++;
       				 return SECTION;
				}

"\\paragraph"[{][a-z A-Z]+[}]	{ //printf("%s",yytext);
                                  yylval.p = (char *) malloc(yyleng+9);
                                 
                                  char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-12);

                                     for(i=11;i<yyleng-1;i++) ch[i-11]=yytext[i]; 
                                     ch[i-11]='\0'; 
                                  

                                   strcpy(yylval.p,"<strong>");
                                 strcat(yylval.p,ch);
                                strcat(yylval.p,"&nbsp;&nbsp;&nbsp;");
                                 strcat(yylval.p,"</strong>");
                                                    
       				 return PARAGRAPH;
				}

"\\subparagraph"[{][a-z A-Z]+[}]	{ //printf("%s",yytext);
                                  yylval.p = (char *) malloc(yyleng+9);
                                 
                                  char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-15);

                                     for(i=14;i<yyleng-1;i++) ch[i-14]=yytext[i]; 
                                     ch[i-14]='\0'; 
                                  

                                   strcpy(yylval.p,"<b>");
                                 strcat(yylval.p,ch);
                                  strcat(yylval.p,"&nbsp;&nbsp;&nbsp;");
                                 strcat(yylval.p,"</b>");
                                 
       				 return SUBPARA;
				}


"\\usepackage{graphicx}"     {   return GRAPHICS;  }

"\\begin{figure}" {  return BFIG;}

"\\end{figure}" { return EFIG;}

"\\caption"[{][a-z A-Z]+[}] {    yylval.p = (char *) malloc(yyleng);

                                 char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-10);

                                     for(i=9;i<yyleng-1;i++) ch[i-9]=yytext[i]; 
                                     ch[i-9]='\0'; 
                                 strcpy(yylval.p,"Figure ");
                                 strcat(yylval.p,figcount); figcount[0]++;
                                  
                                 strcat(yylval.p,": ");
                                 strcat(yylval.p,ch);
                                 
       				 return CAP;}


"\\includegraphics"[{][a-zA-Z._0-9]+[}] {    yylval.p = (char *) malloc(yyleng);

                                 char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-18);

                                     for(i=17;i<yyleng-1;i++) ch[i-17]=yytext[i]; 
                                     ch[i-17]='\0'; 
                                  

                                 strcpy(yylval.p,ch);
                                 
       				 return IFIG; }

"\\subsection"[{][a-z A-Z]+[}]	{ //printf("%s",yytext);
                                  yylval.p = (char *) malloc(yyleng+9);

                                 char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-13);

                                     for(i=12;i<yyleng-1;i++) ch[i-12]=yytext[i]; 
                                     ch[i-12]='\0'; 
                                  scount[0]--;
                                  strcpy(yylval.p,"<h4>");
                                   strcat(yylval.p,scount);scount[0]++;
                                       strcat(yylval.p,".");
                                       strcat(yylval.p,sscount);
                                   strcat(yylval.p,"&nbsp;&nbsp;&nbsp;");
                                 strcat(yylval.p,ch);
                                 strcat(yylval.p,"</h4>");
                            sscount[0]++;
                                 
       				 return SUBSECTION;
				}


"\\textbf"[{][a-z A-Z0-9]+[}]	{ //printf("%s",yytext);
                                  yylval.p = (char *) malloc(yyleng);

                                 char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-9);

                                     for(i=8;i<yyleng-1;i++) ch[i-8]=yytext[i]; 
                                     ch[i-8]='\0'; 
                                  

                                 strcpy(yylval.p,ch);
                                 
       				 return BOLDTEXT;
				}


"\\textit"[{][a-z A-Z0-9]+[}]	{ //printf("%s",yytext);
                                  yylval.p = (char *) malloc(yyleng);

                                 char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-9);

                                     for(i=8;i<yyleng-1;i++) ch[i-8]=yytext[i]; 
                                     ch[i-8]='\0'; 
                                  

                                 strcpy(yylval.p,ch);
                                 
       				 return ITATEXT;
				}


"\\underline"[{][a-z A-Z0-9]+[}]	{ //printf("%s",yytext);
                                  yylval.p = (char *) malloc(yyleng);

                                 char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-9);

                                     for(i=11;i<yyleng-1;i++) ch[i-11]=yytext[i]; 
                                     ch[i-11]='\0'; 
                                  
                                  
                                 strcpy(yylval.p,ch);
                                 
       				 return UNDERLINE;
				}
"\\label"[{][a-z A-Z:0-9]+[}]   {
					yylval.p = (char *) malloc(yyleng);

                                       char ch[100];int i;
                                  
                                    

                                     for(i=11;i<yyleng-1;i++) ch[i-11]=yytext[i]; 
                                     ch[i-11]='\0'; 
                                  
                                scount[0]--;
                                //store[scount[0]-'0']=(char *)malloc(yyleng-13);
                                strcpy(store[scount[0]-'0'],ch);                              
                                scount[0]++;
                                 strcpy(yylval.p,ch);
                               
       				 return LABEL;				
}

"\\ref"[{][a-z A-Z:0-9]+[}]   {  //printf("------------------");
					yylval.p = (char *) malloc(yyleng);

                                        int i,j=0,k=0;
                                  char texp[1];
                                
                                     
                                     for(i=9;i<yyleng-1;i++) texp[i-9]=yytext[i]; 
                                     texp[i-9]='\0'; 
                                    // printf("%s",yytext);
                                     
                                  

                                 for(;j<10;j++){
                                   
                                  // printf("\n%s  %s\n",store[j],texp); 
                                   if(strcmp(store[j],texp)==0) break;

                                   
                                }                                


                                char fp[2]; fp[0]=j+'0'; fp[1]='\0'; 
                                 strcpy(yylval.p,fp);
                                // printf("%d",j);
       				 return REF;				
}



"\\begin{enumerate}" { // printf("%s",yytext);
 yylval.p = (char *) malloc(5); yylval.p="<ol>"; return LIST; }
"\\end{enumerate}" {//printf("%s",yytext);
 yylval.p = (char *) malloc(6); yylval.p="</ol>";return LISTEND; }

"\\begin{itemize}" {// printf("%s",yytext);
  yylval.p = (char *) malloc(5); yylval.p="<ul>"; return ULIST; }
"\\end{itemize}" {//printf("%s",yytext);
 yylval.p = (char *) malloc(6); yylval.p="</ul>";return ULISTEND; }


"\\item"[ ][a-z A-Z.]+[\n] { yylval.p = (char *) malloc(yyleng);
                           
                                 char *ch;int i;
                                  
                                     ch = (char *) malloc(yyleng-6);

                                     for(i=6;i<yyleng;i++) ch[i-6]=yytext[i]; 
                                     ch[i-6]='\0'; 
                                   
                                  //printf("%s",yytext);

                                 strcpy(yylval.p,ch);
                                    return ITEM;
                                  }


"\\end{document}" 		{

                 yylval.p=(char *)malloc(22);
                 strcpy(yylval.p,"</div></body></html>");
				 return ENDDOC;
				}



[a-z A-Z.0-9,']+			{
                                 

                                 if(yyleng==0) yylval.p=(char *)malloc(1);
                                 else yylval.p = (char *) malloc(yyleng);
                                 
                                 if(yyleng==0) strcpy(yylval.p," ");
                                 else
                                 strcpy(yylval.p,yytext);
                                
                                //printf("%s\n",yytext);
                                
				 return TEXT;

				}


"\\begin{tabular}"[{][|][c|]+[}] { printf("btab\n");
 return BTAB;}
"\\end{tabular}" {printf("etab");
return ETAB;}
"\\hline" {printf("hline\n");
return HLINE;}
[\\][\\][ ]* {printf("%s\n",yytext);
return DS;}
[&] {printf("amp\n");
return AMP;}
 






%%


