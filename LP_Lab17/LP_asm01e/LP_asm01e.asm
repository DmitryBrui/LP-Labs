.586                                         
.model flat, stdcall                         
includelib libucrt.lib
includelib kernel32.lib                      
includelib "..\Debug\LP_asm01d.lib"

EXTRN getmax: proc
EXTRN getmin: proc

ExitProcess PROTO: DWORD                     
GetStdHandle PROTO: DWORD									
															
WriteConsoleA PROTO: DWORD,: DWORD,: DWORD,: DWORD,: DWORD	
SetConsoleTitleA PROTO: DWORD								



.stack 4096													

.const														
	consoleTitle byte 'LP_asm01', 0						
	handleOutput sdword -11									
	massiv sdword -10, 15, -25, 4, 2, 8, 34, 11, -16, 27	
	text byte 'getmax-getmin =', 0								

.data
	consoleHandle dword 0h									
	max sdword ?
	min sdword ?
	result sdword ?
	resultString byte 4 dup(0)

.code

int_to_char PROC uses eax ebx ecx edi esi, 
											pstr: dword, 
											intfield: sdword 
    mov edi, pstr						
    mov esi, 0							
    mov eax, intfield					
    cdq
    mov ebx, 10
    idiv ebx
    test eax, 80000000h
    jz plus
    neg eax
    neg edx
    mov cl, '-'
    mov[edi], cl
    inc edi
plus:
    push dx
    inc esi
    test eax, eax
    jz fin
    cdq
    idiv ebx
    jmp plus
fin:
    mov ecx ,esi
write:
    pop bx
    add bl,'0'
    mov[edi], bl
    inc edi
    loop write
    ret
int_to_char ENDP

main PROC							
	INVOKE SetConsoleTitleA, offset consoleTitle			
	INVOKE GetStdHandle,handleOutput			 
	mov consoleHandle, eax						 
	push lengthof massiv
	push offset massiv
    call getmin				                     
    mov min, eax								 
	push lengthof massiv
	push offset massiv
    call getmax									 
    mov max, eax								 
	sub eax, min								 
	mov result, eax								 
	INVOKE WriteConsoleA, consoleHandle,offset text,sizeof text,0,0	 
	INVOKE int_to_char,offset resultString,result
	INVOKE WriteConsoleA, consoleHandle,offset resultString,sizeof resultString,0,0 		
	INVOKE ExitProcess,0			
main ENDP							
end main	