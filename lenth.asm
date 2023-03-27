;Calculate the Length of String
%macro print 2
mov rax,1   ;accumulator register
mov rdi,1   ;
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro 

section .data
m db 10,"ALP to print entered string and its Length",10
l equ $-m
m1 db 10d,"Enter the String: "
l1 equ $-m1
m2 db 10d,"Entered String is: "
l2 equ $-m2
m3 db 10d,13d,"Length: "
l3 equ $-m3

section .bss        ;block starting symb
buffer resb 50      ;reserved byte
size equ $-buffer
count resd 1
dispnum resb 16

section .text
global _start
_start:
print m,l
print m1,l1
read buffer,size
mov [count],rax
print m2,l2
print buffer,[count]
call display

display:
    mov rsi,dispnum+15
    mov rax,[count]
    mov rcx,16   ;counter register
    dec rax
    
    UP1:
        mov rdx,0
        mov rbx,10
        div rbx  ;base register
        add dl,30h
        mov [rsi],dl
        dec rsi
        loop UP1
  print m3,l3 
  print dispnum+14,02
  ret
  
Exit:
    mov rax,60
    mov rbx,0
    syscall
