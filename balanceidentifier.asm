Format PE console
Include 'win32ax.inc'

;=========================================
section '.text' code readable executable
;=========================================
start:
        cinvoke printf, "Enter an equation of ()[]{}: "
        cinvoke scanf, "%s", Equation
        mov [InitialESP], ESP ;save initial stack value
        mov EBX, -1 ;counter / offset

MainLoop:
        inc EBX
        mov EAX, 0  ;Zero out EAX
        mov AL, [Equation+EBX]
        cmp AL, 32      ;Input token is a space - finished!
        je FinishedMainLoop

OpenParenthesis:
        cmp AL, '('
        jne OpenBracket
        push EAX
        jmp MainLoop


OpenBracket:
        cmp AL, '['
        jne OpenBrace
        push EAX
        jmp MainLoop
OpenBrace:
        cmp AL, '{'
        jne CloseParenthesis
        push EAX
        jmp MainLoop


CloseParenthesis:
        cmp AL, ')'
        jne CloseBracket
        cmp ESP, [InitialESP]
        je Unbalanced
        pop ECX
        cmp ECX, '('
        jne Unbalanced
        jmp MainLoop
CloseBracket:
        cmp AL, ']'
        jne CloseBrace
        cmp ESP, [InitialESP]
        je Unbalanced
        pop ECX
        cmp ECX, '['
        jne Unbalanced
        jmp MainLoop
CloseBrace:
        cmp AL, '}'
        jne FinishedMainLoop
        cmp ESP, [InitialESP]
        je Unbalanced
        pop ECX
        cmp ECX, '{'
        jne Unbalanced
        jmp MainLoop


FinishedMainLoop:
        cmp ESP, [InitialESP]
        je Balanced
        jmp Unbalanced


Unbalanced:
        cinvoke printf, "Your Input string is NOT Balanced%c%c", 10, 10
        jmp start
Balanced:
        cinvoke printf, "Your Input string is balanced%c%c", 10, 10
        jmp start



;======================================
section '.data' data readable writeable
;======================================
Equation        db '                                       ' ;40 spaces
InitialESP      dd 0





;====================================
section '.idata' import data readable
;====================================
library msvcrt,'msvcrt.dll',kernel32,'kernel32.dll'
import msvcrt,printf,'printf',scanf,'scanf'
import kerne132, Sleep,'Sleep'
