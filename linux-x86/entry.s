.text
.globl _start
.extern _lsc_start
_start:
	xorl %ebp, %ebp
	movl _lsc_init_ptr, %eax
	movl %esp, (%eax)
	andl $0xFFFFFFF0, %esp
	jmp _lsc_start
.globl _lsc_syscall5
.globl _lsc_syscall4
.globl _lsc_syscall3
.globl _lsc_syscall2
.globl _lsc_syscall1
.globl _lsc_syscall0
_lsc_syscall5:
	movl 28(%esp), $edi
_lsc_syscall4:
	movl 24(%esp), $esi
_lsc_syscall3:
	movl 20(%esp), $edx
_lsc_syscall2:
	movl 16(%esp), $ecx
_lsc_syscall1:
	movl 12(%esp), $ebx
_lsc_syscall0:
	movl 8(%esp), %eax
	xchgl 4(%esp), %ebp
	call *%ebp
	movl 4(%esp), %ebp
	; pass %eax out
	ret

.data
.globl _lsc_init_ptr
_lsc_init_ptr: dd 0
