cc_library(
	name = "linux-x86",
	srcs = ["core.c", "entry.S"],
#	deps = ["linux-x86-assembly"],
	copts = ["-nostdlib", "-nostdinc", "-m32"],
	linkopts = ["-nostdlib", "-nostdinc", "-m32"],
)

#genrule(
#	name = "linux-x86-assembly",
#	srcs = ["entry.s"],
#	outs = ["entry.o"],
#	tools = ["//libsyscall/tools:gas"],
#	cmd = (
#		'for src in $(SRCS); do ' +
#		'  $(location //libsyscall/tools:gas) ' +
#		    ' '.join(ASOPTS) +
#		    ' -o $(GENDIR)/$${src%.asm}.o $${src}; ' +
#		'done'
#	),
#)
