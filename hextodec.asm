processor 16F877
#include <p16f877a.inc>

;Nieto Rodriguez Tomas Andres
;The following program transforms a hex number into a
;decimal number taking one memory address for the unit, 
;another address for the tens and a final address for
;the hundreds.
hex EQU 0x50 ;data in hex
div EQU 0x51 ;divide by ten
quot EQU 0x52 ;quotient
rem EQU 0x53 ;remainder
uni EQU 0x32 ;units
ten EQU 0x31 ;tens
hun EQU 0x30 ;hundreds
i EQU 0x54 ;counter

	org 0
	GOTO start
	org 5

start:
	MOVLW 0x0A
	MOVWF div
	CLRF quot ;initialize quotient to zero
	CLRF rem ;initialize remainder to zero
	CLRF i ;initialize counter to zero

loop:
	MOVF div, W ;Division algorithm
	SUBWF hex, W
	BTFSS STATUS, C ;Skips if there's carry
	GOTO done
	
	INCF quot, F ;Increase quotient
	MOVWF hex
	GOTO loop
done:
	INCF i, F ;Increase counter
	MOVF hex, W 
	MOVWF rem ;Stores remainder
	MOVF i, W
	XORLW 1 ;Checks if counter is equal to one
	BTFSC STATUS, Z
	GOTO unitw ;Goes to write to the units address
	MOVF i, W 
	XORLW 2 ;Checks if counter is equal to two
	BTFSC STATUS, Z
	GOTO tenw ;Goes to write to the tens address
	MOVF i, W
	XORLW 3 ;Checks if counter is equal to three
	BTFSC STATUS, Z
	GOTO hunw ;Goes to write to the hundreds address
unitw: 
	MOVF rem, W
	MOVWF uni ;Writes the remainder in the units address
	MOVF quot, W
	MOVWF hex ;Quotient becomes the next number to divide
	CLRF quot
	CLRF rem
	BCF STATUS, Z ;Clears Z flag
	GOTO loop
tenw:
	MOVF rem, W
	MOVWF ten ;Writes the remainder in the tens address
	MOVF quot, W
	MOVWF hex ;Quotient becomes the next number to divide
	CLRF quot 
	CLRF rem
	BCF STATUS, Z ;Clears Z flag
	GOTO loop
hunw:
	MOVF rem, W 
	MOVWF hun ;Writes the remainder in the hundreds address
	end
	