.586														; система команд (процессор Pentium)
.model flat, stdcall										; модель памяти(плоская), соглашение о вызовах
includelib kernel32.lib										; компановщику: компоновать с kernel32
ExitProcess PROTO: DWORD									; прототип функции для завершения процесса Windows 

.stack 4096

.const
	massiv sdword -10, 15, -23, 4, 2, 8, 34, 11, -16, 27

.data
	min sdword ?

.code

getmin PROC parm1 :DWORD, parm2 :DWORD
	mov esi, parm1          
    mov ecx, parm2
    mov eax, [esi] 
L1:
	cmp [esi], eax
	jl L2
	jmp next
L2:
	mov eax, [esi]
next:
	add esi, 4
	loop L1
	ret          
getmin ENDP

main PROC													; точка входа main
    INVOKE getmin, offset massiv, lengthof massiv			; вызов процедуры getmin
    mov min, eax											; результат в min												
	INVOKE ExitProcess, 0									; завершение процесса Windows
main ENDP													; конец процедуры
end main  