; Read a decimal number and a hexadecimal number from the keyboard. Display the number of 1's of the sum of the two numbers in decimal format. Example:
; a = 32 = 0010 0000b
; b = 1Ah = 0001 1010b
; 32 + 1Ah = 0011 1010b
; The value printed on the screen will be 4

bits 32

global start

extern exit, printf, scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
    a dd 0
    b dd 0
    format1 db "%u", 0
    format2 db "%x", 0
    sol dd 0

segment code use32 class=code
    start:
        push dword a
        push dword format1
        call [scanf]
        add esp, 4*2        ; read a decimal nr, a
        
        push dword b
        push dword format2
        call [scanf]
        add esp, 4*2        ; read a hexadecimal nr, b
        
        mov eax, [a]
        add eax, [b]
        
        repeat:
            test eax, 1
            jz end
            inc dword[sol]
            end:
            shr eax, 1
            jnz repeat
            
        push dword [sol]
        push dword format1
        call [printf]
        add esp, 4*2
        
        push dword 0
        call [exit]