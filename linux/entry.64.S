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
	movq 8(%rsp), %rax
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

.globl lsc_deep_call
.globl lsc_deep_return

lsc_deep_call:
	# %rdi, %rsi, %rdx
	subq $64, %rsp
	movq %rbp, 8(%rsp)
	movq %rbx, 16(%rsp)
	movq %r12, 24(%rsp)
	movq %r13, 32(%rsp)
	movq %r14, 40(%rsp)
	movq %r15, 48(%rsp)
	movq %rsp, (%rdx) # saveaddr**

	xchgq %rdi, %rsi # move param* into first parameter
	call *%rsi # target*

	addq $64, %rsp

	movq $0x01, %rax
	ret

lsc_deep_return:
	movq %rdi, %rsp
	movq 8(%rsp), %rbp
	movq 16(%rsp), %rbx
	movq 24(%rsp), %r12
	movq 32(%rsp), %r13
	movq 40(%rsp), %r14
	movq 48(%rsp), %r15
	addq $64, %rsp
	xorq %rax, %rax
	ret
