bits 32

global solve

extern P, N

segment data use32 class=data
    lenp db 0
    lenn db 0
segment code use32 class=code public 
    solve:
    ; The length of 'sir' will be in ecx
        mov esi, [esp + 4]  ; sir
    
        ;mov ecx, len
        jecxz theend
        ;mov esi, sir
        repeat:
            cmp byte[esi], ' '
            je addnrepeat
            cmp byte[esi], '-'
            je addneg
            
            addpos:
            
            inc byte[lenp]          ; increase the length of the positive numbers array
            looppos: ; we compute the next number and add it to the positive numbers array
                mov edi, P
                mov eax, 0
                mov al, [lenp]
                dec al
                add edi, eax    ; take the value that is already on that position
                
                mov al, [edi]   ; multiply it by 10 
                mov bl, 10
                mul bl
                mov [edi], al
                
                lodsb
                sub al, 30h       ; we subtract 30h from al to transform the character of a digit into the digit itself
                add al, [edi]
                stosb
                
                cmp byte[esi], 0    ; check for end of array
                je theend  
                
                cmp byte[esi], ' '
                jne looppos        ; check if we are out of digits, in which case stop the loop
            jmp endrepeat
            
            addneg: ; we compute the next number and add it to the negative numbers array
            inc esi ; we pass the '-' sign
            inc byte[lenn]          ; increase the length of the negative numbers array
            loopneg:
                mov edi, N
                mov eax, 0
                mov al, [lenn]
                dec al
                add edi, eax    ; take the value that is already on that position
                
                mov al, [edi]   ; multiply it by 10 
                mov bl, 10
                mul bl
                mov [edi], al
                
                lodsb
                sub al, 30h       ; we subtract 30h from edi to transform the character of a digit into the digit itself
                add al, [edi]
                stosb
                
                cmp byte[esi], 0    ; check for end of array
                je theend       
                
                cmp byte[esi], ' '
                jne loopneg        ; check if we are out of digits, in which case stop the loop
            jmp endrepeat
            
            addnrepeat:
            inc esi
            endrepeat: 
            loop repeat
            
        theend:
        mov ecx, 0
        mov cl, [lenn]
        mov [esp + 8], ecx
        mov ecx, 0
        mov cl, [lenp]
        mov [esp + 4], ecx
        ret