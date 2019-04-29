// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Infinite loop
  // check if kbd is not zero
  // if not zero, write -1 in all pixels
  // if zero, write 0 in all pixels

  @8192 // number of words in screen memory map
  D=A
  @t // set to variable t
  M=D

(LOOP)
  @i // offset for screen loop
  M=0

  @KBD
  D=M
  @FILL
  D; JGT
  @CLEAR
  D; JEQ
  
(FILL)
  @i
  D=M
  @t
  D=M-D
  @LOOP
  D; JEQ // exit fill loop once offset is 512 (ie. all of screen has been filled)

  @i
  D=M
  @SCREEN
  A=A+D // set address to SCREEN + offset
  M=-1

  @i
  M=M+1
  
  @FILL
  0; JMP

(CLEAR)
  @i
  D=M
  @t
  D=M-D
  @LOOP
  D; JEQ // exit fill loop once offset is 512 (ie. all of screen has been cleared)

  @i
  D=M
  @SCREEN
  A=A+D // set address to SCREEN + offset
  M=0

  @i
  M=M+1

  @CLEAR
  0; JMP
