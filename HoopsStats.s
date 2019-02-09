#t6 stores list - address is $t6
#t7 stores runner
#t8 stores prev
#t9 stores head
#a2 stores counter - number of nodes in the list
    #FIX: t6 should be current only (not a list) - set a different for last??


.text
main:
    #Initialize counter
    li $a2, 0
    li $a3, 1

allocate:
    #Allocate memory
    li $v0, 9
    li $a0, 80
    syscall
    move $t6, $v0

name:
    #Read name
    li $v0, 4
    la $a0, name_prompt
    syscall

    li $v0, 8
    la $a0, t_name #load name into a0
    li $a1, 64
    syscall

    la $t0, t_name #load name into t0
    li $t2, 10

nameLoop:
    #Read player name
    lb $t1, 0($t0)
    beq $t1, $t2, remove
    addi $t0, $t0, 1
    j nameLoop

remove:
    #Remove space
    sb $0, 0($t0)
    la $t0, t_name
    la $s0, done

compare:
    #Check if name is DONE issue - only checking "D"
    lb $t3, 0($t0)
    lb $s3, 0($s0)

    bne $t3, $s3, loadName

    li $s2, 0
    seq $t4, $t3, $s2
    seq $s4, $s3, $t2
    seq $t5, $t4, $s4
    li $s5, 1
    beq $t5, $s5, print

    addi $t0, $t0, 1
    addi $s0, $s0, 1
    j compare

loadName:
    #Store name
    la $s0, t_name
    li $t1, 0

addName:
    lb $t0, 0($s0)
    sb $t0, 0($t6)
    beq $t0, $0, inc

    addi $t1, $t1, 1
    addi $s0, $s0, 1
    addi $t6, $t6, 1

    j addName

inc:
    sub $t6, $t6, $t1

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
    s.s $f0, 68($t6) #verified stored correctly use float or double??

year:
    li $v0, 4               
    la $a0, year_prompt
    syscall

    li $v0, 5
    syscall

    sw $v0, 72($t6)

next:
    sw $0, 76($t6)
    addi $a2, $a2, 1

    beq $a2, $a3, head

    j init

head:
    move $t9, $t6

    j allocate

init:
    move $t7, $t9 #t7 is runner
    move $t8, $t9 #t8 is prev
    li $s2, 1 #counter for sort
    l.s $f0, 68($t6) #current points is in $f0

    # li $v0, 2
    # mov.s $f12, $f0
    # syscall

sort:
    beq $a2, $s2, allocate
    l.s $f1, 68($t7) #head points is in $f1

    # li $v0, 2
    # mov.s $f12, $f1
    # syscall

    c.lt.s $f0, $f1
    bc1f, swap #issue: swap is not being called
    c.eq.s $f1, $f0
    bc1t, checkName

    addi $t7, $t7, 80 #t7 = t7->next
    addi $t8, $t8, 80
    beq $s2, $a3, trail
    addi $s2, $s2, 1
    j sort

trail:
    addi $t8, $t8, -80
    addi $s2, $s2, 1
    j sort

checkName:
    j allocate

swap:
    # li $v0, 4
    # la $a0, called
    # syscall

    beq $t7, $t9, changeHead

    # addi $t8, $t8, 76
    # move $t8, $t6 #load address of t7 into t8
    # addi $t8, $t8, -76
    sw $t6, 76($t8)
    sw $t7, 76($t6)

    # addi $t6, $t6, 76
    # move $t6, $t7
    # addi $t6, $t6, -76

    j allocate

changeHead:
    # li $v0, 4
    # la $a0, called
    # syscall
    #t7 is current t9 is head
    # move $t8, $t9
    # move $t9, $t6 #head = current

    # li $v0, 4
    # move $a0, $t9
    # syscall

    # li $v0, 4
    # move $a0, $t8
    # syscall

    sw $t9, 76($t6) #ISSUE: this line is changing data
    move $t9, $t6

    # addi $t9, $t9, 80
    li $v0, 4
    # move $a0, $t9
    # addi $t9, $t9, 76
    # move $a0, $t9
    lw $a0, 76($t9)
    syscall
    # move $t9, $t8 #head->next = old head
    # addi $t9, $t9, -76

    # li $v0, 4
    # move $a0, $t9
    # syscall

    # addi $t7, $t7, 80
    # move $t7, $t9 #load address of head into t7->next
    # addi $t7, $t7, -80
    # move $t9, $t7

    j allocate

print:
#Printing from the end
    beqz $a2, exit

    li $v0, 4
    move $a0, $t9
    syscall

    li $v0, 4
    la $a0, space
    syscall

    li $v0, 1
    lw $a0, 64($t9)
    syscall

    li $v0, 4
    la $a0, space
    syscall

    li $v0, 1
    lw $a0, 72($t9)
    syscall

    li $v0, 4
    la $a0, nln
    syscall

    addi $a2, $a2, -1
    # addi $t9, $t9, 80
    lw $t9, 76($t9)
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
    p_name: .space 64
    done: .asciiz "DONE\n"
    equal: .asciiz "Entered done \n"
    nln: .asciiz "\n"
    space: .asciiz " "

    called: .asciiz "called"