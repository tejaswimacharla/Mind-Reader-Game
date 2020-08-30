#MindReaderGame Final Project for CS3340

.data
gamescript1: .asciiz "\n********** Welcome to the Mind Reader Game! ********\nThink of a number between 1 and 63. Six cards will be displayed. After the last one, your number is revealed.\n"
gamescript2: .asciiz "\nStart the game? YES OR NO"
gamescript3: .asciiz "\n\nDo you want to play again? Yes or No\n"

textcard1: .asciiz "\nCARD ONE\n"
textcard2: .asciiz "\nCARD TWO\n"
textcard3: .asciiz "\nCARD THREE\n"
textcard4: .asciiz "\nCARD FOUR\n"
textcard5: .asciiz "\nCARD FIVE\n"
textcard6: .asciiz "\nCARD SIX\n"

prompt1: .asciiz "\nIs your number shown in the above card? "
prompt: .asciiz "\nInput Y for YES OR N for NO!\n"
invalid: .asciiz "\nInvalid input. The input should be just 'y' or 'n'"
result: .asciiz "\nTHE NUMBER YOU WERE THINKING OF WAS: "
thankyou: .asciiz "\nThank You for playing the game."
input: .space 20

number1: .word 1
space: .asciiz " "
value: .word 0
value1: .word 1
endl: .asciiz "\n"
.text

# Start the game
start:
	# display welcome message
	li $v0, 4	# print string
	la $a0, gamescript1
	syscall
	
#To Play Start Sound
	li $t1, 4
	li $a0, 81 		    #pitch ($a0)	
	li $a1, 100		    #duration in milliseconds ($a1)
	li $a2, 100			#instrument ($a2)
	li $a3, 127 		#volume ($a3)
StartSound:
	addi $t1, $t1, -1
	addi $a0, $a0, 10	
  	addi $a1, $a1, 20 		
  	addi $a2, $a2, 4 		
  	la $v0, 33
  	syscall                #calls service 33, playing music
  	bnez  $t1, StartSound

	# prompt user to start the game
	li $v0, 4			
	la $a0, gamescript2
	syscall
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 8 #get input
	la $a0, input
	li $a1, 20
	move $t5, $a0
	syscall
	lb $t6, 2($t5)
	lb $t5, 0($t5)
	bnez $t6, invalidinput	# validate input
	beq $t5, 89, yes0
	beq $t5, 121, yes0
	beq $t5, 78, no0
	beq $t5, 110, no0
	j invalidinput
	yes0:
	j card1
	no0:
	j exit
	
#Card 1 to print card 1
card1: 
li $v0,4
la $a0,textcard1 #it will print prompt
syscall
lw $t3, value1($zero)
while1:
	bgt $t3, 63, continue1
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, space
	syscall
	addi $t3, $t3, 2
	j while1

continue1:
li $v0, 4
la $a0, prompt1
syscall
li $v0, 4
la $a0, prompt
syscall

li $v0, 8 #get input
la $a0, input #
li $a1, 20
move $t5, $a0
syscall
#jal inputvalidation
lb $t6, 2($t5)
lb $t5, 0($t5)
bnez $t6, invalidinput1
beq $t5, 89, yes1
beq $t5, 121, yes1
beq $t5, 78, no1
beq $t5, 110, no1
j invalidinput1
yes1:
lw $t6, value1($zero)
add $t7, $t7, $t6
j card2
no1: 
lw $t6, value1($zero)
add $t7, $t7, $zero
j card2


#if yes, store the value of card1 as 2^0 to a variable
#if not, move to the next card without storing the 2^0
#j card2

card2:
li $v0,4
la $a0,textcard2 #it will print prompt
lw $t3, value1($zero)
lw $t4, value($zero)
sll $t3, $t3, 1
syscall
while2:
	bgt $t3, 63, continue2
	bne $t4, 2, increment2
	addi $t3, $t3, 2
	lw $t4, value($zero)
	j while2
	increment2:
	addi $t4, $t4, 1
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, space
	syscall
	addi $t3, $t3, 1
	j while2
	
continue2:
li $v0, 4
la $a0, prompt1
syscall
li $v0, 4
la $a0, prompt
syscall
li $v0, 8 #get input
la $a0, input #
li $a1, 20
move $t5, $a0
syscall
lb $t6, 2($t5)
lb $t5, 0($t5)
bnez $t6, invalidinput2
beq $t5, 89, yes2
beq $t5, 121, yes2
beq $t5, 78, no2
beq $t5, 110, no2
j invalidinput2
j card2
yes2:
lw $t6, value1($zero)
sll $t6, $t6, 1
add $t7, $t7, $t6
j card3
no2: 
lw $t6, value1($zero)
add $t7, $t7, $zero
j card3
card3:
li $v0, 4
la $a0, textcard3
syscall
lw $t3, value1($zero)
lw $t4, value($zero)
sll $t3, $t3, 2
while3:
	bgt $t3, 63, continue3
	bne $t4, 4, increment3
	addi $t3, $t3, 4
	lw $t4, value($zero)
	j while3
	increment3:
	addi $t4, $t4, 1
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, space
	syscall
	addi $t3,$t3, 1
	j while3
continue3:
li $v0, 4
la $a0, prompt1
syscall
li $v0, 4
la $a0, prompt
syscall
li $v0, 8 #get input
la $a0, input #
li $a1, 20
move $t5, $a0
syscall
lb $t6, 2($t5)
lb $t5, 0($t5)
bnez $t6, invalidinput3
beq $t5, 89, yes3
beq $t5, 121, yes3
beq $t5, 78, no3
beq $t5, 110, no3
j invalidinput3
yes3:
lw $t6, value1($zero)
sll $t6, $t6, 2
add $t7, $t7, $t6
j card4
no3: 
lw $t6, value1($zero)
add $t7, $t7,$zero
j card4
card4:
li $v0, 4
la $a0, textcard4
syscall
lw $t3, value1($zero)
lw $t4, value($zero)
sll $t3, $t3, 3
while4:
	bgt $t3, 63, continue4
	bne $t4, 8, increment4
	addi $t3, $t3, 8
	lw $t4, value($zero)
	j while4
	increment4:
	addi $t4, $t4, 1
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, space
	syscall
	addi $t3,$t3, 1
	j while4
continue4:
li $v0, 4
la $a0, prompt1
syscall
li $v0, 4
la $a0, prompt
syscall
li $v0, 8 #get input
la $a0, input #
li $a1, 20
move $t5, $a0
syscall
lb $t6, 2($t5)
lb $t5, 0($t5)
bnez $t6, invalidinput4
beq $t5, 89, yes4
beq $t5, 121, yes4
beq $t5, 78, no4
beq $t5, 110, no4
j invalidinput4
yes4:
lw $t6, value1($zero)
sll $t6, $t6, 3
add $t7, $t7, $t6
j card5
no4: 
lw $t6, value1($zero)
add $t7, $t7,$zero
j card5
card5:
li $v0, 4
la $a0, textcard5
syscall
lw $t3, value1($zero)
lw $t4, value($zero)
sll $t3, $t3, 4
while5:
	bgt $t3, 63, continue5
	bne $t4, 16, increment5
	addi $t3, $t3, 16
	increment5:
	addi $t4, $t4, 1 
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, space
	syscall
	addi $t3, $t3, 1
	j while5
continue5:
li $v0, 4
la $a0, prompt1
syscall
li $v0, 4
la $a0, prompt
syscall
li $v0, 8 #get input
la $a0, input #
li $a1, 20
move $t5, $a0
syscall
lb $t6, 2($t5)
lb $t5, 0($t5)
bnez $t6, invalidinput5

beq $t5, 89, yes5
beq $t5, 121, yes5
beq $t5, 78, no5
beq $t5, 110, no5
j invalidinput5
yes5:
lw $t6, value1($zero)
sll $t6, $t6, 4
add $t7, $t7, $t6
j card6
no5: 
lw $t6, value1($zero)
add $t7, $t7,$zero
j card6
card6:
li $v0, 4
la $a0, textcard6
syscall 
lw $t3, value1($zero)
lw $t4, value($zero)
sll $t3, $t3, 5
while6:
	bgt $t3, 63, continue6
	bne $t4, 32, increment6
	increment6:
	addi $t4, $t4, 1
	li $v0, 1
	move $a0, $t3
	syscall 
	li $v0, 4
	la $a0, space
	syscall
	addi $t3, $t3, 1
	j while6
continue6:
li $v0, 4
la $a0, prompt1
syscall
li $v0, 4
la $a0, prompt
syscall
li $v0, 8 #get input
la $a0, input #
li $a1, 20
move $t5, $a0
syscall
lb $t6, 2($t5)
lb $t5, 0($t5)
bnez $t6, invalidinput6

beq $t5, 89, yes6
beq $t5, 121, yes6
beq $t5, 78, no6
beq $t5, 110, no6
j invalidinput6
yes6:
lw $t6, value1($zero)
sll $t6, $t6, 5
add $t7, $t7, $t6
j output
no6: 
lw $t6, value1($zero)
add $t7, $t7,$zero
j output
#output 
output:
li $v0, 4
la $a0, result
syscall
li $v0, 1
move $a0, $t7
syscall
# Result sound when user inputs incorrect input
sucess:
	li $a3, 125
  	li $a0, 121 
	li $a1, 700		# half second - duration in milliseconds ($a1)
  	li $a2, 78		#instrument ($a2)	72
  	la $v0, 33
  	syscall

lw $t7, value($zero)
li $v0, 4
la $a0, gamescript3
syscall
li $v0, 4
la $a0, prompt
syscall
li $v0, 8 #get input
la $a0, input #
li $a1, 20
move $t5, $a0
syscall
lb $t6, 2($t5)
lb $t5, 0($t5)
bnez $t6, invalidinput
beq $t5, 89, yesoutput
beq $t5, 121, yesoutput
beq $t5, 78, nooutput
beq $t5, 110, nooutput
j invalidinput
yesoutput:
j start


nooutput:

li $v0, 4
la $a0, thankyou
syscall

# End Program 
	li $t1, 4
	li $a0, 121	
	li $a1, 350
	li $a2, 116	
	li $a3, 100
StopSound:
	addi $t1, $t1, -1
	addi $a0, $a0, -10			#pitch ($a0)
  	addi $a1, $a1, -20  		# half second - duration in milliseconds ($a1)
  	addi $a2, $a2, -2		#instrument ($a2)
  	addi $a3, $a3, 2 		#volume ($a3)
  	la $v0, 33
  	syscall                #calls service 33, playing music
  	bnez  $t1, StopSound
j exit
exit:
li $v0, 10
syscall 

# Warning sound when user inputs incorrect input
Warning:
	li $a3, 127
  	li $a0, 108 
	li $a1, 360		# half second - duration in milliseconds ($a1)
  	li $a2, 124		#instrument ($a2)
  	la $v0, 33
  	syscall
  	jr $ra
  	
invalidinput: 
jal Warning
li $v0, 4
la $a0, invalid
syscall
j start
invalidinput1:
jal Warning
li $v0, 4
la $a0, invalid
syscall
j card1
invalidinput2:
jal Warning
li $v0, 4
la $a0, invalid
syscall
j card2
invalidinput3:
jal Warning
li $v0, 4
la $a0, invalid
syscall
j card3
invalidinput4:
jal Warning
li $v0, 4
la $a0, invalid
syscall
j card4
invalidinput5:
jal Warning
li $v0, 4
la $a0, invalid
syscall
j card5
invalidinput6:
jal Warning
li $v0, 4
la $a0, invalid
syscall
j card6

