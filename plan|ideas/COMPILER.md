# Compiler

# Model (plan)
bn.nim (controller)
**lexer.pl** -> lexemes (json)
1. (Lexeme) Lexeme object (col, ln)
2. (string) Seperate by line
3. (string) Ignore after #
4. (string) Go character by character and reset current_segment if character is " " while making list
5. (array) Replace segment with more segments based on regex
6. (Lexeme array) Use switch statement for Lexeme making
**tokenizes** -> tokens ->
**etc**
