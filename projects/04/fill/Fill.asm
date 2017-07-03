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

// infinite loop
// check if KBD > 0 ? jmp fill screen loop : jmp clear screen loop
// fill screen loop
// sets each word from SCREEN to end of SCREEN map to -1
// clear screen loop
// sets each word from SCREEN to end of SCREEN map to 0

  @8192
  D=A
  @count
  M=D
(LOOP)
  @index
  M=0
(INNER)
  @KBD
  D=M
  @WHITE
  D;JEQ
(BLACK)
  @index
  D=M
  @SCREEN
  A=A+D
  M=-1
  @END
  0;JMP
(WHITE)
  @index
  D=M
  @SCREEN
  A=A+D
  M=0
(END)
  @index
  MD=M+1
  @count
  D=D-M
  @LOOP
  D;JEQ
  @INNER
  0;JMP
