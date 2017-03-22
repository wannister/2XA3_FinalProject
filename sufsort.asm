%include "asm_io.inc"

global asm_main

SECTION .data

err1: db "incorrect number of command line arguments",10,0
err2: db "argument must be between 1 and 30 characters",10,0
err3: db "argument must be characters 0 and 1 and 2",10,0

SECTION .bss

X: resb 30
N: resd 1
n: resd 1
i: resd 1
j: resd 1
SECTION .text

asm_main:
	enter 0,0
	pusha

	mov eax, dword [ebp+8]
	cmp eax, dword 2
	jne ERR1                ;right number of arguments

	mov ebx, dword [ebp+12]
	mov eax, dword [ebx+4]
	mov edx, 0

error_loop:
	cmp byte [eax], 0
	je error_loop_done

	cmp byte [eax], '0'
	jl ERR3
	cmp byte [eax], '2'
	jg ERR3
	add edx, 1
	add eax, 1
	jmp error_loop

error_loop_done:
	cmp edx,30
	jg ERR2

	mov [N], dword edx
	mov ecx, X
	mov eax, dword [ebp+12]
	mov ebx, dword [eax+4]
	mov [n], dword 0

copy_loop:
	cmp [n], edx
	jge copy_loop_end
	mov al, byte [ebx]
	mov [ecx], al
	add ecx, dword 1
	add ebx, dword 1
	add [i], dword 1
	jmp copy_loop

copy_loop_end:
	mov eax, X
	call print_string
	call print_nl
	jmp asm_main_end

ERR1:
	mov eax, err1
	call print_string
	jmp asm_main_end
ERR2:
	mov eax, err2
	call print_string
	jmp asm_main_end
ERR3:
	mov eax, err3
	call print_string
	jmp asm_main_end

asm_main_end:
	popa
	leave
	ret

sufcmp:
	enter 0,0
	pusha

	mov eax, dword[ebp+8]
	mov ebx, dword[ebp+8]
	mov ecx, dword[ebp+12]
	mov edx, dword[ebp+16]
	add eax, ecx
	add ebx, edx
sufloop:
	cmp eax, 0
	je RETMINUS
	cmp ebx, 0
	je RETPLUS
	cmp eax, ebx
	jg RETPLUS
	jl RETMINUS	
	add ecx, 1
	add edx, 1
	jmp sufloop
RETMINUS:
	popa
	mov eax, 1
	jmp sufend
RETPLUS:
	popa
	mov eax, -1
sufend: leave
	ret
