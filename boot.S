/*
1 . BIOS loads this MBR to 0x7c00.
2 . I just followed the long jump to start execution.
3 . This ljmp sets CS to 0x0, and IP to xxxx(specified by lable _entry_point)
4 . When ljmp sets CS to 0x007c0, it doesn't work
5 . SS => 0x09000, SP => 0x0fb00, so actual stack data location is SS:SP. That is 0x090000 + 0x0fb00 => 0x09fb00
6 . So stack size is 0x0fb00
*/

.code16
.section .text

bios_entry:
  ljmp $0x00, $safe_jump

safe_jump:
  xorw  %ax, %ax	/* zero's the ax */

  movw  %ax, %ds	/* zero's all ds, es, gs, fs segments  */
  movw  %ax, %es
  movw  %ax, %gs
  movw  %ax, %fs

  movw  $0x09000, %ax	/* setting ss */
  movw  %ax, %ss
  movw  $0x0fb00, %sp	/* set sp */
  movw  $0x0fb00, %bp

  pushw  %dx		/* dl reg has the booted drive number, need to save because we can use hereafter */
  
  xorw  %dx, %dx
  movw  $0x0200, %ax	/* ah => 02 - set cursor position */
  int  $0x010

  movw  $0x001b, %cx	/* string length */
  movw  $0x0007, %bx	/* bh => 00 - page number, bl => 07 - color attribute */
  movw  $welcome_message, %bp	/* bb points to string offset */
  movw  $0x1301, %ax	/* ah => 13 - write string, al => 01 - write mode */
  int  $0x010
  
hang:
  hlt			/* halt the execution */
  jmp  hang

welcome_message:
  .ascii "Welcome To The REAL MODE..."	/* string to be printed on screen */

.section .boot_signature
  .word 0xaa55		/* boot signature linked by ld linker */
