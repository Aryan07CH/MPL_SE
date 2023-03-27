%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
msg db "Counting +ve & -ve elements of an array.",10
msglen equ $-msg
msg1 db "Positive nos. are: "
msglen1 equ $-msg1
msg2 db "Negative nos. are:"
msglen2 equ $-msg2

array dq 7574h,0ADEh,4673h,9532h,7474h,0921h
pcnt db 0
ncnt db 0
newline db 10

section .bss
dispbuff resb 2

section .text
global _start
_start:
print msg,msglen
mov rsi,array
mov rcx,06

again:
	bt qword[rsi],63
	jnc pnxt
	inc byte[ncnt]
	jmp pskip
 pnxt: inc byte[pcnt]
 pskip: inc rsi
loop again
print msg1,msglen1
mov bl,[pcnt]
call disp_result
print newline,1

print msg2,msglen2
mov bl,[ncnt]
call disp_result
print newline,1

mov rax,60
mov rdi,0
Syscall

disp_result:
    mov rdi,dispbuff
    mov rcx,02
  dispup1:
      rol bl,4
      mov dl,bl
      and dl,0fh
      add dl,30h
      cmp dl,39h
      jbe dispskip1
      add dl,07h
  dispskip1:
      mov [rdi],dl
      inc rdi
      loop dispup1
      print dispbuff,2
    ret
