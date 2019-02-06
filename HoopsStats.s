main:
    li $v0, 4
    la $a0, name_prompt
    syscall

    li $v0, 8
    la $a0, t_name
    li $a1, 64
    syscall

    la $t0, t_name
    li $t2, 10

readName:
    #Read player name
    lb $t1, 0($t0)
    beq $t1, $t2, markDone
    addi $t0, $t0, 1
    j readName

markDone:
    sb $0, 0($t0)
    la $t0, t_name
    la $s0, done

compare:
    #Check if name is DONE
    lb $t3, 0($t0)
    lb $s3, 0($s0)

    seq $t4, $t3, 0
    seq $s4, $s3, $t2
    seq $t5, $t4, $s4
    li $s5, 1
    beq $t5, $s5, sort

    bne $t2, $s2, readStats

    addi $t0, $t0, 1
    addi $s0, $s0, 1
    j compare

readStats:
    #Read player stats
    li $v0, 4               #Get number
    la $a0, number_prompt
    syscall
    li $v0, 5
    syscall
    move $s0, $v0

    li $v0, 4               #Get points
    la $a0, points_prompt
    syscall
    li $v0, 6
    syscall
    move $s1, $v0

    li $v0, 4               #Get year
    la $a0, year_prompt
    syscall
    li $v0, 5
    syscall
    move $s2, $v0

build:
    li $v0, 9 #create space for a new player
    li $a0, 80
    syscall

    la $t0, t_name
    lw $t0, 0($t3) #name
    lw $s0, 64($t3) #number
    lw $s1, 68($t3) #points
    lw $s2, 76($t3) #year

    #ADD 32 bits for the next 
    #1. malloc space for player
    #2. copy player data
    #3. add to players
    
sort:
    li $v0, 4
    la $a0, equal
    syscall

clean:

.data
.align 2
    name_prompt: .asciiz "Enter the player's name:\n"
    number_prompt: .asciiz "Enter the player's number:\n"
    points_prompt: .asciiz "Enter the player's average points per game: \n"
    year_prompt: .asciiz "Enter the player's year:\n"
    t_name: .space 64

    # bb_player: 
    #     bb_player.name  .space 64
    #     bb_player.number .space 4
    #     bb_player.points .space 8
    #     bb_player.year .space 4
        # .float 
        # .integer

    done: .asciiz "DONE"

    equal: .asciiz "Entered done \n"