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
    move $t6, $v0 #t6 stores current node

name:
    #Read name
    li $v0, 4
    la $a0, name_prompt
    syscall

    li $v0, 8
    la $a0, t_name
    li $a1, 64
    syscall

    la $t0, t_name
    li $t2, 10

remove:
    #Remove newline
    lb $t1, 0($t0)
    beq $t1, $t2, end
    addi $t0, $t0, 1
    j remove

end:
    #End name in 0
    sb $0, 0($t0)

    la $t0, t_name
    la $s0, done

compare:
    #Check if done
    lb $t3, 0($t0)
    lb $s3, 0($s0)

    seq $t4, $t3, $0
    seq $s4, $s3, $0
    
    add $t5, $s4, $s4
    li $s5, 2
    beq $t5, $s5, print

    bne $t3, $s3, loadName

    addi $t0, $t0, 1
    addi $s0, $s0, 1
    j compare

loadName:
    #Load name into temp
    la $s0, t_name
    li $t1, 0

storeName:
    #Store name
    lb $t0, 0($s0)
    sb $t0, 0($t6)
    beq $t0, $0, inc

    addi $t1, $t1, 1
    addi $s0, $s0, 1
    addi $t6, $t6, 1

    j storeName

inc:
    #Reset current
    sub $t6, $t6, $t1

number:
    #Read player number
    li $v0, 4               
    la $a0, number_prompt
    syscall

    li $v0, 5
    syscall
    sw $v0, 64($t6)

points:
    #Read player points
    li $v0, 4               
    la $a0, points_prompt
    syscall

    li $v0, 6
    syscall
    s.s $f0, 68($t6)

year:
    #Read player year
    li $v0, 4               
    la $a0, year_prompt
    syscall

    li $v0, 5
    syscall

    sw $v0, 72($t6)

next:
    #Create next
    sw $0, 76($t6)
    addi $a2, $a2, 1

    beq $a2, $a3, head

    j init

head:
    #Create head
    move $t9, $t6 #t9 stores head
    j allocate

init:
    #Create runners
    move $t7, $t9 #t7 stores next
    move $t8, $t9 #t8 stores prev
    li $s2, 1
    l.s $f0, 68($t6)

sort:
    #Sort by points then name
    beq $a2, $s2, last
    l.s $f1, 68($t7)

    c.lt.s $f1, $f0
    bc1t, swap

    c.eq.s $f1, $f0
    bc1t, saveName

    lw $t7, 76($t7)
    beq $s2, $a3, skip
    addi $s2, $s2, 1
    lw $t8, 76($t8)

    j sort

skip:
    #Don't move runner
    addi $s2, $s2, 1
    j sort

last:
    #Current is last
    sw $t6, 76($t8)
    j allocate

saveName:
    #Store names in temps
    move $s6, $t6
    move $s7, $t7

checkName:
    #Compare names
    lb $s4, 0($s6)
    lb $s5, 0($s7)
    blt $s4, $s5, swap
    bgt $s4, $s5, else
    addi $s6, $s6, 1
    addi $s7, $s7, 1
    j checkName

swap:
    #Swap $t6 and $t7
    beq $t7, $t9, changeHead

    sw $t6, 76($t8)
    sw $t7, 76($t6)

    j allocate

else:
    #Place after
    addi $s2, $s2, 1
    lw $t7, 76($t7)
    lw $t8, 76($t8)

    beq $s2, $a2, last
    l.s $f1, 68($t7)
    c.eq.s $f1, $f0
    bc1t, saveName

    sw $t6, 76($t8)
    sw $t7, 76($t6)

    j allocate

changeHead:
    #Change head
    sw $t9, 76($t6)
    move $t9, $t6

    j allocate

print:
    #Print elements
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
    lw $t9, 76($t9)
    j print

exit:
    jr $ra

.align 2
.data
    name_prompt: .asciiz "Enter the player's name:\n"
    number_prompt: .asciiz "Enter the player's number:\n"
    points_prompt: .asciiz "Enter the player's average points per game: \n"
    year_prompt: .asciiz "Enter the player's year:\n"
    
    t_name: .space 64
    
    done: .asciiz "DONE"
    nln: .asciiz "\n"
    space: .asciiz " "