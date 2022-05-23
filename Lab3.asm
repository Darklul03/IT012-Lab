.data
	arraySize: .word
	array: .space 400
	sizePrompt: .asciiz "Nhap so phan tu [1-100]: "
	sizeError: .asciiz "So phan tu phai thuoc [1-100].\n"
	positivePrompt: .asciiz "Nhap cac so nguyen khong am.\n"
	inpPrompt: .asciiz "Nhap phan tu thu "
	inpPromptHelper: .asciiz ": "
	inpError: .asciiz "Phan tu phai la so khong am.\n"
	sep: .asciiz " "
	nl: .asciiz "\n"

.text
main:
	sizeLoop:
		li $v0, 4
		la $a0, sizePrompt
		syscall

		li $v0, 5
		syscall

		slti $t8, $v0, 1
		sgt $t9, $v0, 100
		or $t7, $t8, $t9
		beq $t7, 0, endSizeLoop

		li $v0, 4
		la $a0, sizeError
		syscall
		j sizeLoop

	endSizeLoop:
	sw $v0, arraySize
	move $t0, $v0
	li $t1, 1
	la $t2, array

	li $v0, 4
	la $a0, positivePrompt
	syscall
	li $v0, 4
	la $a0, nl
	syscall

	# t0: n, t1: i, s0: array
	# for i = 1->n: input(a[i])
	inpForLoop:
		inpLoop:
			li $v0, 4
			la $a0, inpPrompt
			syscall
			li $v0, 1
			move $a0, $t1
			syscall
			li $v0, 4
			la $a0, inpPromptHelper
			syscall # Nhap phan tu thu i: 
			
			li $v0, 5
			syscall
			bge $v0, 0, endInpLoop
			
			li $v0, 4
			la $a0, inpError
			syscall
			j inpLoop

		endInpLoop:
		sw $v0, 0($t2)
		addi $t1, $t1, 1
		addi $t2, $t2, 4
		ble $t1, $t0, inpLoop

	endInpForLoop:
	li $t1, 1
	la $t2, array

	#print(*array)
	outForLoop:
		li $v0, 1
		lw $a0, 0($t2)
		syscall
		li $v0, 4
		la $a0, sep
		syscall
		
		addi $t1, $t1, 1
		addi $t2, $t2, 4
		ble $t1, $t0, outForLoop

	endOutForLoop:
	li $v0, 10
	syscall
