;
; SequenceGame.asm
;
; Created: 15-Mar-18 23:39:10
; Author : Shishir
;

;configuration of port
	ldi r16, 0xff						;loading register r16 with 0b1111_1111
		out ddra, r16					;data direction register to port a
	ldi r22, 0xff						;loading register r22 with 0b1111_1111
		out ddra, r22					;data direction register to port a
	ldi r17, 0x00						;loading register r17 with 0b0000_0000
		out ddrb, r17					;data direction register to port b
	ldi r21, 0x00						;loading register r21 with 0b0000_0000
		out ddrb, r21					;data direction register to port b

;address memory
	LDI XL, 0x00						;point to the low address memory
	LDI XH, 0x02						;point to the high address memory

	ldi r25, 0x00						;loading data on register r25 with 0b0000_0000
	ldi r23, 0x01						;it is the number of level
	ldi r30, 0x08						;loading data on register r30 with 0b0000_1000
	ldi r31, 0x08						;loading data on register r30 with 0b0000_1000

	call start							;calling the start sequence
main:
	sequence:
		mov r24, r23					;r24 is temporary memory
		loop_load:
			call load					;generates the sequences
			out porta, r16				;write to the port A
			st X+, r16					;adds to the new address
			call delay					;wait for the led to light up
		
			ldi r18, 0b1111_1111		;loading the value to hide the sequence
			out porta, r18				;write to the port A
			call delay
			
		dec r24							;decreasing register24 by 1
		brne loop_load
	
		mov r24, r23
		loop_X:
			ld r22, -X					;reseting the pointer to the first element
			dec r24						
			brne loop_X

		mov r24, r23
		loop_input:
			ld r22, X+					;pointing to the next element
			call user_input				
			cp r22, r17					;comparing the user's input
			brne wrong
			call delay
			dec r24
			brne loop_input
	mov r24, r23
		loop_Y:
			ld r22, -X					;reseting the pointer to the first element
			
			dec r24						
			brne loop_Y
			call correct
	dec r31
brne main		
	call ending
end:
	rjmp end

	user_input:
		in r17, pinb
		com r17
		breq user_input
		com r17
	ret

	wrong:
		ldi r16, 0x0f					;0000_1111
		out porta, r16					;write to port
		call delay
		ldi r16, 0xf0					;1111_0000
		out porta, r16					;write to port
		call delay
		ldi r16, 0xff					;1111_1111
		out porta, r16					;write to port
		call delay
	ret

	load:
		mov r28, r23
	loop_11:							;loop for generating "random numbers"
		inc r25
		cp r25, r30				
		breq back_to_zero				;value of r25 loops between 0 and 7
		dec r28
		brne loop_11
	
		ldi r29, 0x00
		cp r25, r29						;load_1 - 8 loads the value for led 1 - 8
		breq load_1						

		ldi r29, 0x01
		cp r25, r29
		breq load_2

		ldi r29, 0x02
		cp r25, r29
		breq load_3

		ldi r29, 0x03
		cp r25, r29
		breq load_4

		ldi r29, 0x04
		cp r25, r29
		breq load_5

		ldi r29, 0x05
		cp r25, r29
		breq load_6

		ldi r29, 0x06
		cp r25, r29
		breq load_7

		ldi r29, 0x07
		cp r25, r29
		breq load_8
		ret

	load_1:
	ldi r16,0b1111_1110
	ret

	load_2:
	ldi r16,0b1111_1101
	ret

	load_3:
	ldi r16,0b1111_1011
	ret

	load_4:
	ldi r16,0b1111_0111
	ret

	load_5:
	ldi r16,0b1110_1111
	ret

	load_6:
	ldi r16,0b1101_1111
	ret

	load_7:
	ldi r16,0b1011_1111
	ret

	load_8:
	ldi r16,0b0111_1111
	ret

	back_to_zero:
	ldi r25,0b0000_0000
	inc r28
	call loop_11
	ret

	start:
		ldi r16, 0x00			;loading with value 0000_0000 
		out porta, r16			;writing to the port
		call delay
		ldi r16, 0x18			;loading with value 0001_1000
		out porta, r16			;writing to the port
		call delay
		ldi r16, 0x3c			;loading with value 0011_1100
		out porta, r16			;writing to the port				
		call delay
		ldi r16, 0x7e			;0111_1110
		out porta, r16			;write to port
		call delay
		ldi r16, 0xff			;1111_1111
		out porta, r16			;write to port
		call delay
		ldi r16, 0x00			;loading with value 0000_0000 
		out porta, r16			;writing to the port
		call delay
		ldi r16, 0xff			;1111_1111
		out porta, r16			;write to port
		call delay
		ret	

	correct:
		inc r23
		ldi r16, 0x7e			;loading with value 0111_1110 
		out porta, r16			;write to port
		call delay
		ldi r16, 0xff			;1111_1111
		out porta, r16			;write to port
		call delay
		ldi r16, 0x7e			;loading with value 0111_1110 
		out porta, r16			;write to port
		call delay
		ldi r16, 0xff			;1111_1111
		out porta, r16			;write to port
		call delay
		ret

	ending:
		ldi r16, 0x00			;loading with value 0000_0000 
		out porta, r16			;writing to the port
		call delay

		ldi r16, 0x81			;loading with value 1000_0001
		out porta, r16			;writing to the port
		call delay
		
		ldi r16, 0xc3			;loading with value 1100_0011
		out porta, r16			;writing to the port				
		call delay
		
		ldi r16, 0xe7			;loading with value 1110_0111
		out porta, r16			;write to port
		call delay
		
		ldi r16, 0xff			;loading with value1111_1111
		out porta, r16			;write to port
		call delay

end2:
	rjmp end2


delay:
		ldi r18, 255
	loop_1:
		ldi r19, 255
	innerloop_1:
		ldi r20, 10
	insideloop_1:
		dec r20
		brne insideloop_1
		dec r19
		brne innerloop_1
		dec r18
		brne loop_1
		ret