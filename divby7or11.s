.text
main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall

    move $a1, $v0 #a1 stores total
    li $a2, 0 #a2 stores counter
    li $a3, 6 #a3 stores current int

    li $v0, 4
    la $a0, nln
    syscall

loop:
    beq $a2, $a1, done
    addi $a3, $a3, 1

    li $s0, 7
    div $a3, $s0
    mfhi $t2
    beqz $t2, by7

    li $s0, 11
    div $a3, $s0
    mfhi $t2
    bnez $t2, loop

by7:
    addi $a2, $a2, 1
    li $v0, 1
    move $a0, $a3
    syscall

    li $v0, 4
    la $a0, nln
    syscall

    j loop

done:
    jr $ra

.data
.align 2
    prompt: .asciiz "Please enter an integer:\n"
    nln: .asciiz "\n"