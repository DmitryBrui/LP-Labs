.586														
.model flat, stdcall										
includelib kernel32.lib										
includelib "..\Debug\LP_asm01a.lib"

ExitProcess PROTO: DWORD									
GetStdHandle PROTO: DWORD									
															
WriteConsoleA PROTO: DWORD,: DWORD,: DWORD,: DWORD,: DWORD	
SetConsoleTitleA PROTO: DWORD								

getmin PROTO :DWORD, :DWORD
getmax PROTO :DWORD, :DWORD

.stack 4096

.const
	massiv			sdword		-10, 15, -23, 4, 2, 8, 34, 11, -16, 27
	consoleTitle	byte		'LP_asm01', 0
	text			byte		'getmax-getmin =', 0							
	handleOutput	sdword		-11						    

.data
	consoleHandle dword 0h									
	max sdword ?
	min sdword ?
	result sdword ?
	resultString byte 4 dup(0)

.code

int_to_char PROC uses eax ebx ecx edi esi,		
							  pstr: dword,  ; адрес строки результат
						  intfield: sdword  ; преобразуемое число
    mov edi, pstr                           ; адрес результата в -> edi
    mov esi, 0			            ; количество символов в результате						
    mov eax, intfield								
    cdq								; преобразование 2го слова в учетверенное копирование знакового бита регистра eax на все биты регистра edx						
    mov ebx, 10                     ; десятичная система счисления
    idiv ebx						; aex = eax/ebx, остаток -> edx					
    test eax, 80000000h				; результат отрицательный ?							
    jz plus							; если результат предыдущей команды 0, т.е.положительный то на plus							
    neg eax							; eax = -eax			
    neg edx                         ; edx = -edx
    mov cl, '-'                     ; первый символ результата '-'
    mov[edi], cl
    inc edi							; ++edi							
plus:
    push dx                         ; остаток -> стек
    inc esi                         ; ++esi
    test eax, eax					; eax == 0?							
    jz fin                          ; если да то на fin
    cdq                             ; знак распространили с eax на edx
    idiv ebx                        ; aex = eax/ebx, остаток -> edx
    jmp plus
fin:
    mov ecx ,esi                    ; количество ненулевых остатков = количеству символов в результате
write:
    pop bx							; остаток из стека -> bx							
    add bl,'0'                      ; сформировали символ в bl
    mov[edi], bl                    ; bl-> в результат
    inc edi                         ; edi++
    loop write                      ; if (--ecx) > 0 goto write
    ret
int_to_char ENDP

main PROC
	INVOKE SetConsoleTitleA, offset consoleTitle		
	INVOKE GetStdHandle,handleOutput			        
	mov consoleHandle, eax						        
    INVOKE getmin, offset massiv,lengthof massiv
    mov min, eax
    INVOKE getmax, offset massiv,lengthof massiv
	sub eax, min
	mov result, eax
	INVOKE WriteConsoleA, consoleHandle, offset text, sizeof text, 0, 0							
    INVOKE int_to_char, offset resultString, result	
	INVOKE WriteConsoleA, consoleHandle, offset resultString, sizeof resultString, 0, 0			
	INVOKE ExitProcess,0
main ENDP
end main   