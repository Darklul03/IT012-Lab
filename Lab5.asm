.data
    array: .space 400
    arraySize: .word 0
    sum: .word 0
    min: .word 0
    max: .word 0
    cntEven: .word 0
    cntOdd: .word 0
    
    sizePrompt: .asciiz "Nhap so phan tu [1-100]: "
    sizeError: .asciiz "So phan tu phai thuoc [1-100].\n"
    positivePrompt: .asciiz "Nhap cac so nguyen duong.\n"
    inpPrompt: .asciiz "Nhap phan tu thu "
    inpPromptHelper: .asciiz ": "
    inpError: .asciiz "Phan tu phai la so duong.\n"
    sortPrompt: .asciiz "\n\n1. Bubble sort\n2. Interchange sort\n3. Gnome sort\nThuat toan sap xep: "
    bubblePrompt: .asciiz "Bubble sort: "
    interchangePrompt: .asciiz "Interchage sort: "
    gnomePrompt: .asciiz "Gnome sort: "

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
    jal printArr
    li $v0, 4
    la $a0, sortPrompt
    syscall
    
    li $v0, 5
    syscall
    
    move $s7, $v0
    
    beq $s7, 1, bub
    beq $s7, 2, inter
    beq $s7, 3, gnome
    bub:
        jal bubbleAsc
        j endSort
    inter:
        jal interchangeAsc
        j endSort
    gnome:
        jal gnomeAsc
        j endSort
        
    endSort:
    jal printArr
    j exit

printArr:
    li $v0, 4
    la $a0, nl
    syscall
    
    lw $t0, arraySize
    li $t1, 1
    la $t2, array
    forPrintLoop:
        li $v0, 1
        lw $t8, 0($t2) # t8 = a[i]
        move $a0, $t8
        syscall
        li $v0, 4
        la $a0, sep
        syscall # print a[i]

        addi $t1, $t1, 1
        addi $t2, $t2, 4
        ble $t1, $t0, forPrintLoop
    endForPrintLoop:
    jr $ra
    
bubbleAsc:
    lw $t0, arraySize
    move $t6, $t0
    li $t8, 1
    la $t2, array
    
    #t8: i, t9: j
    #for i : (1->n-1)
    #    for j : (1->n-i)
    #        if (a[j] > a[j+1]) swap
    bAILoop:
       move $t3, $t2 # t3(temp) = a + 4i
       li $t9, 1
       bAJLoop:
           addi $t4, $t2, 0
           lw $t4, 0($t4)
           addi $t5, $t2, 4
           lw $t5, 0($t5)
           bgt $t4, $t5, swapBAsc #if (a[j] > a[j+1])
           j endSwapBAsc
           swapBAsc:
               sw $t4, 4($t2)
               sw $t5, 0($t2)
           endSwapBAsc:
           addi $t9, $t9, 1
           addi $t2, $t2, 4
           blt $t9, $t6, bAJLoop
       endBAJLoop:
       subi $t6, $t6, 1
       move $t2, $t3
       addi $t8, $t8, 1
       blt $t8, $t0, bAILoop
   endBAILoop:
   jr $ra
   
interchangeAsc:
    lw $t0, arraySize
    li $t8, 1
    la $t2, array
    
    #t8: i, t9: j
    #for i : (1->n-1)
    #    for j : (i+1->n)
    #        if (a[i] > a[j]) swap
    iAILoop:
       move $t3, $t2 # t3(temp) = a + 4i
       lw $t4, 0($t2) # t4 = a[i]
       addi $t2, $t2, 4
       addi $t9, $t8, 1 # j = i + 1
       iAJLoop:
           addi $t5, $t2, 0
           lw $t5, 0($t5)
           bgt $t4, $t5, swapIAsc #if (a[i] > a[j])
           j endSwapIAsc
           swapIAsc:
               add $t4, $t4, $t5
               sub $t5, $t4, $t5
               sub $t4, $t4, $t5 # swap t4, t5
               sw $t4, 0($t3)
               sw $t5, 0($t2)
           endSwapIAsc:
           addi $t9, $t9, 1
           addi $t2, $t2, 4
           ble $t9, $t0, iAJLoop
       endIAJLoop:
       move $t2, $t3
       addi $t8, $t8, 1
       addi $t2, $t2, 4
       blt $t8, $t0, iAILoop
   endIAILoop:
   jr $ra
   
gnomeAsc:
    lw $t0, arraySize
    li $t8, 1
    la $t2, array
    
    #Gnome sort
    #t8: i = 1
    #while (i <= n)
    #    if (i == 1 || a[i] >= a[i-1]) -> i++
    #    else -> swap(a[i], a[i-1), i--
    gAILoop:
        beq $t8, 1, gACheck
        lw $t4, 0($t2)
        lw $t5, -4($t2)
        bge $t4, $t5, gACheck
        j gADec
        gADec:
            sw $t4, -4($t2)
            sw $t5, 0($t2)
            subi $t8, $t8, 1
            subi $t2, $t2, 4
            j gAILoop
        gACheck:
            addi $t8, $t8, 1
            addi $t2, $t2, 4
            ble $t8, $t0, gAILoop
    endGAILoop:
    jr $ra
    
exit:
    li $v0, 10
    syscall