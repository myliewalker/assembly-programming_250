.text
main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $a0, $v0

    move $t2, $a0

f:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    beqz $a0, base

    add $s0, $a0, $0
    addi $a0, $a0, -1

    jal f

    li $t0, 4
    mul $s1, $s0, $t0 
    li $t1, 2
    mul $s2, $v0, $t1
    add $v0, $s1, $s2
    addi $v0, $v0, 3 

    addi $t2, $t2, -1
    bnez $t2, clean

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

.data
    prompt: .asciiz "Please enter an integer:\n" #should newline character be separate?
    nln: .asciiz "\n"