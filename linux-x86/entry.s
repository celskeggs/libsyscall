.text
.globl _start
.extern _lsc_main
_start:
	xorl %ebp, %ebp
	movl _lsc_init_ptr, %eax
	movl %esp, (%eax)
	andl $0xFFFFFFF0, %esp
	jmp _lsc_main
.globl _lsc_syscall
_lsc_syscall:
	movl (%esp), %eax
	movl 4(%esp), $ebx
	movl 8(%esp), $ecx
	movl 12(%esp), $edx
	movl 16(%esp), $esi
	movl 20(%esp), $edi
	pushl %ebp
	movl _lsc_syscall_ptr, %ebp
	movl (%ebp), %ebp
	call *%ebp
	popl %ebp
	; pass %eax out
	ret

.data
.globl _lsc_init_ptr
_lsc_init_ptr: dd 0
.globl _lsc_syscall_ptr
_lsc_syscall_ptr: dd 0
