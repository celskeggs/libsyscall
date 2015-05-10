#!/usr/bin/env python3
from string import Template
assert(print) # make sure that python3 is in use

c_normal = Template("""
int lsc_$name($args) {
	return _lsc_syscall$argc(__SYS_$name $args_raw);
}
""")
c_noreturn = Template("""
void lsc_$name($args) {
	_lsc_syscall$argc(__SYS_$name $args_raw);
	__builtin_unreachable();
}
""")

h_normal = Template("""
#define __SYS_$name $num
extern int lsc_$name($args);
""")
h_noreturn = Template("""
#define __SYS_$name $num
extern void lsc_$name($args) __attribute__((noreturn));
""")

def rawify_argument(arg):
	raw = arg.split(" ")[-1].strip()
	if raw[0] == "*":
		raw = "(int) " + raw[1:]
	return raw

with open("syscalls.tab", "r") as f:
	with open("syscall.c", "w") as c:
		with open("libsyscall.h", "w") as h:
			with open("libsyscall.h.base", "r") as b:
				for line in b:
					if line.strip() == "/* FOOTER */":
						break # don't include the footer at the top
					h.write(line)
			with open("syscall.c.base", "r") as b:
				for line in b:
					c.write(line)
			for line in f:
				if not line.strip(): continue
				name, num, *args = [seg.strip() for seg in line.split(",")]
				noreturn = num.strip() == "noreturn"
				if noreturn:
					num, *args = args

				mapping = {"name": name, "num": num}
				mapping["argc"] = len(args)
				mapping["args"] = ", ".join(args) or "void"
				mapping["args_raw"] = "".join(", " + rawify_argument(arg) for arg in args)

				c.write((c_noreturn if noreturn else c_normal).substitute(mapping))
				h.write((h_noreturn if noreturn else h_normal).substitute(mapping))
			with open("libsyscall.h.base", "r") as b:
				for line in b:
					if line.strip() == "/* FOOTER */":
						break
				for line in b: # start at the footer
					h.write(line)
