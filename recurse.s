.text
main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    
    move $a0, $v0

f:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    #base case
    beqz $a0, base

    add $s0, $a0, $0
    li $t1, 1
    sub $a0, $a0, $t1
    jal f

    li $t0, 4
    mul $s1, $s0, $t0 
    li $t1, 2
    mul $s2, $v0, $t1
    add $s3, $s1, $s2
    addi $v0, $s3, 3 

    move $a2, $v0

    # move $a0, $v0
    # li $v0, 1
    # syscall

    # la $a0, nln
    # li $v0, 4
    # syscall

base:
    li $v0, 5
    move $a1, $a0
    li $a0, 5
    j clean

clean:
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    beqz $a1, print

    jr $ra

print:
    li $v0, 1
    move $a0, $a2
    syscall

    li $v0, 4
    la $a0, nln
    syscall

    jr $ra

.data
    prompt: .asciiz "Please enter an integer:\n" #should newline character be separate?
    nln: .asciiz "\n"
