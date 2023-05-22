
%macro print 2                                   ;define macro along with parameters
  mov rax,1                                         ;standard output
  mov rdi,1                                         ; input write
  mov rsi,%1                                       ;display message address
  mov rdx,%2                                      ;message length
  syscall                                            ;interrupt for kernel in 64-bit
%endmacro
%macro accept 2                                    ;define macro along with parameters
  mov rax,0                                         ;standard input ()   
  mov rdi,0                                         ;standard read
  mov rsi,%1                                        ;display message address
  mov rdx,%2                                       ;message length
  syscall                                            ;interrupt for kernel in 64-bit
%endmacro

section .data
  nwline db 10
  m0 db 10,10,"Program to multiply two numbers using successive addition"
  l0 equ $-m0
  m1 db 10,"1. Successive Addition method",10,"2. exit",10,10, "Enter your choice (1/2 <ENTER>): "
  l1 equ $-m1
  m2 db 10,"Enter multiplicand (2 digit HEX no) : "
  l2 equ $-m2
  m3 db 10,"Enter multiplier (2 digit HEX no) : "
  l3 equ $-m3
  m4 db 10,"The Multiplication is : "
  l4 equ $-m4
  Th db 10, "Thank You"
  tl equ $-Th

section .bss
  mcand resb 02 ;reserve 1 quad for multiplicand
  mplier resb 02 ;reserve 1 quad for multiplier
  choice resb 02 ;reserve 2 byte [1 for choice and 1 for enter]
  numascii resb 04
  dispbuff resb 02

section .text
  global _start ;starting of the program
  _start:
  print m0,l0
  print m1,l1
  accept choice,02
  cmp byte[choice] ,"1"
  je add
  cmp byte[choice],"2"
  je exit
  add:
    print m2,l2
    accept numascii,03
    call ascii2hnum
    mov [mcand],bl
  print m3,l3
  accept numascii,03
  call ascii2hnum
  mov [mplier],bl
  print m4,l4
  mov rax,0                                     ;clearing rax register
  cmp byte[mplier],0                              ;compare contents of mplier buffer in qword with 0
  jz ll5                                     ;if zero jump to loop 5

  ll1:                                          ;loop 1
    add rax,[mcand]                   ;add contents of mcand buffer in qword to contentsof raxregister
    dec byte[mplier]                       ;decrement contents of mplier buffer
    jnz ll1                              ;if not zero jump to loop 1

  ll5:                                        ;loop 5
    call display
  exit:
    print Th,tl
    mov rax,60
    mov rdi,0
    syscall
  ascii2hnum:
     mov bl,0                              ;clear bx register
     mov rcx,02                            ;count of 4 for enter 4 hex numbers
     mov rsi,numascii                       ;move contents of numascii into rsi
                                          ;takes ascii value of entered number

  up1:
    rol bl,04                                ;rotate the value in bx register by 4 counts
    mov al,[rsi]                            ;move contents of rsi(ascii value) into al registers
    cmp al,39h                           ;compare contents of al register with 39h
    jbe skip1                           ;if compared value is below(less) than 39h then jump to skip1
    sub al,07h                           ;if compared value is greater than 39h
                                        ;then subtract 07h from contents of al register

  skip1:
    sub al,30h                           ;subtract 30h from the contents of al register
    add bl,al                            ;add the contents of al register to the bl register
    inc rsi                             ;increment the contents of rsi
    loop up1                           ;perform the loop up 1 functions again
    ret                                ;return
  display:
    mov rdi,dispbuff
    mov rcx,02
  up2:
    rol al,04
    mov dl,al
    and dl,0fh
    add dl,30h
    cmp dl,39h
    jbe dispskip1
    add dl,07h
  dispskip1:
    mov [rdi],dl
    inc rdi
    loop up2
    print dispbuff,2
  ret

