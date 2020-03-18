bits 32

global start

extern exit, scanf, printf

import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    cuvant times 32 db 0
    cuvant_nou times 32 db 0
    n dd 0
    format_string db '%s', 0
    format_dec db '%d', 0
    vocale db "aeiouAEIOU", 0

segment code use32 class=code
    start:
        ; citeste cuvant
        push dword cuvant
        push dword format_string
        call [scanf]
        add esp, 4*2
        ;citeste numar
        push dword n
        push dword format_dec
        call [scanf]
        add esp, 4*2
        
        mov eax, 1
        and eax, [n]
        jp par
        
        ; impar
        mov esi, cuvant
        mov edi, cuvant_nou
        criptare:
            ; ia o litera
            lodsb
            
            ; s-a terminat cuvantul
            cmp al, 0
            je afisare
            
            ; verifica daca vocala
            mov ecx, 10
            vocala:
                mov ebx, vocale
                add ebx, ecx
                dec ebx
                
                cmp al, [ebx]
                je addp
                loop vocala
                
            stosb
            ; daca nu a fost vocala, mergi mai departe
            jmp criptare
            addp:
            stosb
            mov bl, al
            mov al, 'p'
            stosb 
            mov al, bl
            stosb 
            jmp criptare
            
        ; criptare par    
        par:
        mov esi, cuvant
        mov edi, cuvant_nou
        criptare2:
            lodsb
            
            ; s-a terminat cuvantul
            cmp al, 0
            je afisare
            
            add al, 20
            stosb
            jmp criptare2
        
        afisare:
        ; afiseaza
        push dword cuvant_nou
        push dword format_string
        call [printf]
        add esp, 4*2
        
        push dword 0
        call [exit]