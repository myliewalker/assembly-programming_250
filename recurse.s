.text
main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $a0, $v0

    move $t0, $a0 #t0 stores input

f:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    beqz $a0, base

    add $s0, $a0, $0
    addi $a0, $a0, -1

    jal f

    li $t1, 4
    mul $s1, $s0, $t1 
    li $t2, 2
    mul $s2, $v0, $t2
    add $v0, $s1, $s2
    addi $v0, $v0, 3 

    addi $t0, $t0, -1
    bnez $t0, clean

    move $v1, $v0

    move $a0, $v0
    li $v0, 1
    syscall

    la $a0, nln
    li $v0, 4
    syscall

    move $v0, $v1
    j clean

base:
    li $v0, 5
    j clean

clean:
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    jr $ra

.align 2
.data
    prompt: .asciiz "Please enter an integer:\n"
    nln: .asciiz "\n"