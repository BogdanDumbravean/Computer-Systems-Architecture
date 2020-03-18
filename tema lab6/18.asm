; A string of doublewords is given. Order in increasing order the string of the high words (most significant) from these doublewords. The low words (least significant) remain unchanged.
; Example:
; being given
; sir DD 12AB5678h, 1256ABCDh, 12344344h 
; the result will be
; 12345678h, 1256ABCDh, 12AB4344h.
bits 32 

global start        

extern exit               
import exit msvcrt.dll    

segment data use32 class=data
    sir dd 12AB5678h, 1256ABCDh, 12344344h
    len1 equ ($-sir)/4
    aux times len1 dd 0

; our code starts here
segment code use32 class=code
    start:
        cld
        mov esi, sir
        mov edi, aux
        mov ecx, len1
        
        jecxz ending
        copy:
            lodsd
            stosd
            loop copy                       ; copy array in auxiliary array
            
            
        mov edi, aux
        mov ecx, len1
        loop1:
            mov esi, edi
            add esi, 4                      ; Begin from next step
            mov edx, ecx                    
            sub edx, 1                      ; Number of steps from current position to the end of the array
            jz endLoop2
           
            loop2:
                lodsd
                cmp eax, [edi]
                jae pass
                mov ebx, [edi]
                mov [esi - 4], ebx
                mov [edi], eax              ; swap if we find a bigger value
                
                pass:
                dec edx
                cmp edx, 0
                ja loop2
            endLoop2:
            add edi, 4
            loop loop1
            
            
        mov esi, aux
        mov edi, sir
        mov ecx, len1
        solve:
            lodsd 
            and eax, 0FFFF0000h     ; take high word from sorted array
            mov ebx, 0FFFFh
            and ebx, [edi]          ; take low word from original array
            or eax, ebx
            stosd                   ; replace value in sorted array
            
            loop solve
           
        ending:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
