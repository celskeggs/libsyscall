.text
.globl _start
.extern _lsc_start
.extern _lsc_init_ptr
_start:
	xorl %ebp, %ebp
	movl %esp, _lsc_init_ptr(,1)
	andl $0xFFFFFFF0, %esp
	jmp _lsc_start

.extern _lsc_vdso_ptr
.globl _lsc_syscall5
.globl _lsc_syscall4
.globl _lsc_syscall3
.globl _lsc_syscall2
.globl _lsc_syscall1
.globl _lsc_syscall0

_lsc_syscall5:
	xchgl 24(%esp), %edi
_lsc_syscall4:
	xchgl 20(%esp), %esi
	movl 16(%esp), %edx
	movl 12(%esp), %ecx
	xchgl 8(%esp), %ebx
	movl 4(%esp), %eax
	call *_lsc_vdso_ptr(,1)
	movl 20(%esp), %esi
	movl 24(%esp), %edi
	# pass %eax out
	ret

_lsc_syscall3:
	movl 16(%esp), %edx
_lsc_syscall2:
	movl 12(%esp), %ecx
_lsc_syscall1:
	xchg 8(%esp), %ebx
	movl 4(%esp), %eax
	call *_lsc_vdso_ptr(,1)
	movl 8(%esp), %ebx
	# pass %eax out
	ret

_lsc_syscall0:
	movl 4(%esp), %eax
	jmp *_lsc_vdso_ptr(,1)
