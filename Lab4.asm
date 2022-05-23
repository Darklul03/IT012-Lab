.data
    array: .space 400
    arraySize: .word
    sizePrompt: .asciiz "Nhap so phan tu [1-100]: "
    sizeError: .asciiz "So phan tu phai thuoc [1-100].\n"
    positivePrompt: .asciiz "Nhap cac so nguyen duong.\n"
    inpPrompt: .asciiz "Nhap phan tu thu "
    inpPromptHelper: .asciiz ": "
    inpError: .asciiz "Phan tu phai la so duong.\n"
    sumPrompt: .asciiz "Tong cac phan tu: "
    minPrompt: .asciiz "Gia tri nho nhat: "
    maxPrompt: .asciiz "Gia tri lon nhat: "
    numEvenPrompt: .asciiz  "So phan tu chan: "
    numOddPrompt: .asciiz "So phan tu le: "
    sep: .asciiz " "
    nl: .asciiz "\n"

.text
main:
    sizeLoop:
        li $v0, 4
        la $a0, sizePrompt # "Nhap so phan tu [1-100]
        syscall

        li $v0, 5
        syscall

        slti $t8, $v0, 1
        sgt $t9, $v0, 100
        or $t7, $t8, $t9
        beq $t7, 0, endSizeLoop

        li $v0, 4
        la $a0, sizeError # "So phan tu phai thuoc [1-100].
        syscall
        j sizeLoop

    endSizeLoop:
    sw $v0, arraySize
    move $t0, $v0
    li $t1, 1
    la $t2, array

    li $v0, 4
    la $a0, positivePrompt # "Nhap cac so nguyen duong."
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
            syscall # "Nhap phan tu thu i: "

            li $v0, 5
            syscall
            bgt $v0, 0, endInpLoop # Kiem tra phan tu duong

            li $v0, 4
            la $a0, inpError # "Phan tu phai la so duong."
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
    li $t3, 0
    lw $t4, 0($t2)
    lw $t5, 0($t2)
    li $t6, 0
    li $t7, 0

    #t0: n, t1 : i, t2: base address
    #t3: sum, t4: min, t5: max
    #t6: num even, t7: num odd
    outForLoop:
        li $v0, 1
        lw $t8, 0($t2) # t8 = a[i]
        move $a0, $t8
        syscall
        li $v0, 4
        la $a0, sep
        syscall # print a[i]

        # Sum
        add $t3, $t3, $t8

        # Min
        ble $t4, $t8, endMin # min <= a[i]
        move $t4, $t8

        endMin:
        # Max
        bge $t5, $t8, endMax # max >= a[i]
        move $t5, $t8

        endMax:
        andi $t9, $t8, 1
        beq $t9, 1, numOdd # LSB a[i] == 1

        numEven:
            addi $t6, $t6, 1
            j endNum

        numOdd:
            addi $t7, $t7, 1

        endNum:
        addi $t1, $t1, 1
        addi $t2, $t2, 4
        ble $t1, $t0, outForLoop

    endOutForLoop:
    li $v0, 4
    la $a0, nl
    syscall
    la $a0, sumPrompt # "Tong cac phan tu: "
    syscall
    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, nl
    syscall
    la $a0 ,minPrompt # "Gia tri nho nhat: "
    syscall
    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, nl
    syscall
    la $a0, maxPrompt # "Gia tri lon nhat: "
    syscall
    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, nl
    syscall
    la $a0, numEvenPrompt # "So phan tu chan: "
    syscall
    li $v0, 1
    move $a0, $t6
    syscall

    li $v0, 4
    la $a0, nl
    syscall
    la $a0, numOddPrompt # "So phan tu le: "
    syscall
    li $v0, 1
    move $a0, $t7
    syscall

    li $v0, 10
    syscall
