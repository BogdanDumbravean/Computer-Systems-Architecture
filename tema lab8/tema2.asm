; A text file is given. The text contains letters, spaces and points. Read the content of the file, determine the number of words and display the result on the screen. (A word is a sequence of characters separated by space or point)
bits 32

global start

extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll 
import printf msvcrt.dll 

segment data use32 class=data
    inputfile db 'a.txt', 0
    modread db 'r', 0
    handle dd -1
    c db 0
    printformat db '%u', 0
    count dd 0

segment code use32 class=code
    start:
        ; fopen(string path, string mode) - opens the file path in the specified mode
        push dword modread ; for strings, the offset is pushed on the stack
        push dword inputfile ; for strings, the offset is pushed on the stack
        call [fopen]
        add esp, 4*2
        
        ; fopen returns in EAX the file handle or zero (in case of error)
        ; this file handle is just a dword used by the operating system and is required for all subsequent
        ; function calls that work with this file.
        mov [handle], eax ; store the handle in a local variable
        cmp eax, 0
        je theend ; if error, move to the end of the program

        mov bl, 0
        mov dword[count], 0
        repeat:
            ;fread(string ptr, integer size, integer n, FILE * handle) - reads n times size bytes from the
            ; file identified by handle and place the read bytes in the string ptr.
            ; we read 1 byte from the file handle
            push dword [handle] ; read from handle
            push dword 1 ; read 1 time
            push dword 1 ; read 1 byte
            push dword c ; store the byte in c
            call [fread]
            add esp, 4*4

            cmp eax, 0 ; the function returns zero in EAX in case of error
            je error
            
            cmp byte [c], '.'
            je increment
            cmp byte [c], ' '
            je increment
            
            mov bl, 1
            jmp continue
            
            increment:
                cmp bl, 0
                je continue
                
                mov bl, 0
                add dword [count], 1
            
            continue:
                jmp repeat
            
        error:
            ; fclose(FILE* handle) - close the file identified by handle
            push dword [handle]
            call [fclose]
            add esp, 4*1
       
        ; print the count
        push dword [count] 
        push dword printformat
        call [printf]
        add esp, 4*2
       
        theend:
        push dword 0
        call [exit]