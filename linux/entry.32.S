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
.globl _lsc_syscall6
.globl _lsc_syscall5
.globl _lsc_syscall4
.globl _lsc_syscall3
.globl _lsc_syscall2
.globl _lsc_syscall1
.globl _lsc_syscall0

_lsc_syscall6:
_lsc_syscall5:
_lsc_syscall4:
	xchgl 28(%esp), %ebp
	xchgl 24(%esp), %edi
	xchgl 20(%esp), %esi
	movl 16(%esp), %edx
	movl 12(%esp), %ecx
	xchgl 8(%esp), %ebx
	movl 4(%esp), %eax
	call *_lsc_vdso_ptr(,1)
	movl 8(%esp), %ebx
	movl 20(%esp), %esi
	movl 24(%esp), %edi
	movl 28(%esp), %ebp
	# pass %eax out
	ret

_lsc_syscall3:
	movl 16(%esp), %edx
_lsc_syscall2:
	movl 12(%esp), %ecx
_lsc_syscall1:
	xchgl 8(%esp), %ebx
	movl 4(%esp), %eax
	call *_lsc_vdso_ptr(,1)
	movl 8(%esp), %ebx
	# pass %eax out
	ret

_lsc_syscall0:
	movl 4(%esp), %eax
	jmp *_lsc_vdso_ptr(,1)

.globl lsc_deep_call
.globl lsc_deep_return

lsc_deep_call:
	# movl 8(%esp), %eax # target*
	# movl 12(%esp), %ecx # param*
	movl 16(%esp), %edx # saveaddr**
	subl $24, %esp
	movl %ebx, 4(%esp)
	movl %esi, 8(%esp)
	movl %edi, 12(%esp)
	movl %ebp, 16(%esp)
	movl %esp, (%edx)

	pushl 28(%esp) # param*
	call *24(%esp) # target*

	addl $28, %esp

	movl $0x01, %eax
	ret

lsc_deep_return:
	movl 8(%esp), %esp # loadaddr*
	movl 4(%esp), %ebx
	movl 8(%esp), %esi
	movl 12(%esp), %edi
	movl 16(%esp), %ebp
	addl $24, %esp
	xorl %eax, %eax
	ret
