; Read from file numbers.txt a string of numbers (positive and negative). Build two strings using readen numbers:
; P – only with positive numbers
; N – only with negative numbers
; Display the strings on the screen.

bits 32

global start

extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll

extern solve

global P 
global N

segment data use32 class=data public 
    input_file db "numbers.txt", 0
    modread db 'r', 0
    handle dd -1
    c db 0
    printformat db '%d', 0
    sir times 100 db 0
    len db 0
    
    P times 50 db 0
    N times 50 db 0
    
    newline db 10, 0
    space db 20h, 0
    stringformat db '%s', 0

segment code use32 class=code
    start:
        ; open the file path
        push dword modread
        push dword input_file
        call [fopen]
        add esp, 4*2
        
        mov [handle], eax
        cmp eax, 0
        je theend
        
        mov esi, sir
        repeat:
            ; read from file
            push dword [handle]
            push dword 1
            push dword 1
            push dword esi
            call [fread]
            add esp, 4*4
            
            cmp eax, 0
            je error
            
            inc esi
            inc byte[len]
            
            jmp repeat
        
        error:
            ; close the file identified by handle
            push dword [handle]
            call [fclose]
            add esp, 4*1
        
        mov ecx, 0
        mov cl, [len]
        push dword sir
        call solve
        
        ; print positive numbers
        mov esi, P
        pop ebx  ; lenp
        cmp ebx, 0
        je endprint1
        print1:
            mov eax, 0
            lodsb
            push eax
            push dword printformat
            call [printf]
            add esp, 4*2
            
            push dword space        ; print space
            push dword stringformat
            call [printf]
            add esp, 4*2
            
            dec ebx
            jnz print1
        endprint1:
        
        push dword newline        ; print endl
        push dword stringformat
        call [printf]
        add esp, 4*2
        
        ; print negative numbers
        mov esi, N
        pop ebx  ; lenn
        cmp ebx, 0
        je theend
        print2:
            lodsb
            cbw
            cwde
            neg eax
            push eax
            push dword printformat
            call [printf]
            add esp, 4*2
            
            push dword space        ; print space
            push dword stringformat
            call [printf]
            add esp, 4*2
            
            dec ebx
            jnz print2
        
        theend:
        push dword 0
        call [exit]
        