#t6 stores list
#t7 stores counter
.text
main:
    li $v0, 9 #create space for a new player
    li $a0, 112
    syscall
    move $t6, $v0

    li $t7, 0

name:
    li $v0, 4
    la $a0, name_prompt
    syscall

    li $v0, 8
    la $a0, t_name
    li $a1, 64
    syscall

    la $t0, t_name
    li $t2, 10

nameLoop:
    #Read player name
    lb $t1, 0($t0)
    beq $t1, $t2, remove
    addi $t0, $t0, 1
    j nameLoop

remove:
    sb $0, 0($t0)
    la $t0, t_name
    la $s0, done

compare:
    #Check if name is DONE
    lb $t3, 0($t0)
    lb $s3, 0($s0)

    bne $t3, $s3, addName

    li $s2, 0
    seq $t4, $t3, $s2
    seq $s4, $s3, $t2
    seq $t5, $t4, $s4
    li $s5, 1
    beq $t5, $s5, print

    addi $t0, $t0, 1
    addi $s0, $s0, 1
    j compare

addName:
    #Store name
    la $t0, t_name
    sw $t0, 0($t6)

number:
    #Read player stats
    li $v0, 4               
    la $a0, number_prompt
    syscall

    li $v0, 5
    syscall
    sw $v0, 64($t6)

points:
    li $v0, 4               
    la $a0, points_prompt
    syscall

    li $v0, 6
    syscall  
    s.s $f0, 68($t6)

year:
    li $v0, 4               
    la $a0, year_prompt
    syscall

    li $v0, 5
    syscall
    sw $v0, 76($t6)

next:
    sw $0, 80($t6)
    addi $t7, $t7, 1

    j main

# sort:
#     j print

print:
    beqz $t7, exit

    li $v0, 4
    lw $a0, 0($t6)
    syscall

    li $v0, 4
    la $a0, space
    syscall

    li $v0, 1
    lw $a0, 64($t6)
    syscall

    li $v0, 4
    la $a0, space
    syscall

    # li $v0, 2
    # lw $f12, 64($t6)
    # syscall

    li $v0, 1
    lw $a0, 76($t6)
    syscall

    li $v0, 4
    la $a0, nln
    syscall

    addi $t7, $t7, -1
    addi $t6, $t6, -112
    j print

exit:
    jr $ra

.data
.align 2
    name_prompt: .asciiz "Enter the player's name:\n"
    number_prompt: .asciiz "Enter the player's number:\n"
    points_prompt: .asciiz "Enter the player's average points per game: \n"
    year_prompt: .asciiz "Enter the player's year:\n"
    
    t_name: .space 64
    done: .asciiz "DONE\n"
    equal: .asciiz "Entered done \n"
    nln: .asciiz "\n"
    space: .asciiz " "