.text
.globl _start
.extern _lsc_start
.extern _lsc_init_ptr
_start:
	xorq %rbp, %rbp
	movq %rsp, _lsc_init_ptr(,1)
	andq $0xFFFFFFFFFFFFFFF0, %rsp
	jmp _lsc_start

.globl _lsc_revsyscall6
.globl _lsc_revsyscall5
.globl _lsc_revsyscall4
.globl _lsc_revsyscall3
.globl _lsc_revsyscall2
.globl _lsc_revsyscall1
.globl _lsc_revsyscall0

_lsc_revsyscall6:
	popq %rax
	movq %rcx, %r10
	# movq %r8, %r8
	# movq %r9, %r9
	syscall
	ret

_lsc_revsyscall5:
	movq %rcx, %r10
	# movq %r8, %r8
	movq %r9, %rax
	syscall
	ret

_lsc_revsyscall4:
	movq %rcx, %r10
	movq %r8, %rax
	syscall
	ret

_lsc_revsyscall3:
	movq %rcx, %rax
	syscall
	ret

_lsc_revsyscall2:
	movq %rdx, %rax
	syscall
	ret

_lsc_revsyscall1:
	movq %rsi, %rax
	syscall
	ret

_lsc_revsyscall0:
	movq %rdi, %rax
	syscall
	ret
