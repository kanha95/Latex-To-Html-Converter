

void yyerror(char*,...);
void itoa(int n, char s[]);
void reverse(char s[]);


/* nodes in the abstract syntax tree */
struct ast {
char nodetype;
struct ast *left;
struct ast *right;
};

struct str {
char nodetype;
char *value;
};

/* build an AST */
struct ast *newast(char nodetype, struct ast *left, struct ast *right);
struct ast *newstr(char* value);

/* evaluate an AST */
char* eval(struct ast *);

