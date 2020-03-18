bits 32

global _solve

segment data use32 class=data
    ten db 10
    AddressP dd 0
    lenp db 0
    AddressN dd 0

segment code use32 class=code public 
_solve:
	; creating a stack frame for the called program
	push ebp
	mov ebp, esp
	pushad

    mov ecx, [ebp + 8]  ; mov len in ecx
    mov esi, [ebp + 12]  ; move sir in esi
	; Move the addresses of arrays P and N
	mov eax, [ebp + 16]	
	mov edi, eax			; keep address of P in edi
	mov eax, [ebp + 20]
	mov edx, eax		    ; keep address of N in edx
	mov bx, 0				; use bl and bh as lengths of arrays

	jecxz theend
	;mov esi, sir
	repeat:
		cmp byte[esi], ' '
		je addnrepeat
		cmp byte[esi], '-'
		je addneg
            
		addpos:
            
		inc bl          ; increase the length of the positive numbers array
		looppos: ; we compute the next number and add it to the positive numbers array
			push edi
			mov eax, 0
			mov al, bl
			dec al
			add edi, eax    ; take the value that is already on that position
                
			mov al, [edi]   ; multiply it by 10 
			mul byte[ten]
			mov [edi], al
                
			lodsb
			sub al, 30h
			add al, [edi]
			stosb
                
			pop edi

			cmp byte[esi], 0    ; check for end of array
			je theend  
                
			cmp byte[esi], ' '
			jne looppos        ; check if we are out of digits, in which case stop the loop
		jmp endrepeat
            
		addneg: ; we compute the next number and add it to the negative numbers array
		inc esi ; we pass the '-' sign
		inc bh          ; increase the length of the negative numbers array
		loopneg:
			; Swap edi and edx
			push edi
			push edx
			pop edi
			pop edx
			; End of swap

			push edi

			mov eax, 0
			mov al, bh
			dec al
			add edi, eax    ; take the value that is already on that position
                
			mov al, [edi]   ; multiply it by 10 
			mul byte[ten]
			mov [edi], al
                
			lodsb
			sub al, 30h
			add al, [edi]
			stosb

			pop edi

			; Swap edi and edx
			push edi
			push edx
			pop edi
			pop edx
            ; End of swap
			
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
	; restore the stack frame for the caller program
	popad
	mov esp, ebp
	pop ebp

    ret