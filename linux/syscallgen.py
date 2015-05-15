#!/usr/bin/env python3
from string import Template
import sys

assert(print) # make sure that python3 is in use

c_normal = Template("""
$return lsc_$name($args) {
	return$cast _lsc_syscall$argc(__SYS_$name $args_raw);
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
extern $return lsc_$name($args);
""")
h_noreturn = Template("""
#define __SYS_$name $num
extern void lsc_$name($args) __attribute__((noreturn));
""")

def rawify_argument(arg):
	raw = arg.split(" ")[-1].strip()
	if raw[0] == "*":
		raw = "(lsc_int_t) " + raw[1:]
	return raw

assert len(sys.argv) == 3, "Bad number of arguments to syscallgen.py. Expects libsyscall.h.base and syscalls.tab"

with open(sys.argv[2], "r") as f:
	with open("syscall.c", "w") as c:
		with open("libsyscall.h", "w") as h:
			with open(sys.argv[1], "r") as b:
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
				ret_type, cast = "lsc_int_t", ""
				if noreturn:
					num, *args = args
				elif not num.isdigit():
					ret_type = num
					cast = "(%s)" % num
					num, *args = args

				mapping = {"name": name, "num": num}
				mapping["argc"] = len(args)
				mapping["args"] = ", ".join(args) or "void"
				mapping["args_raw"] = "".join(", " + rawify_argument(arg) for arg in args)
				mapping["return"] = ret_type
				mapping["cast"] = cast

				c.write((c_noreturn if noreturn else c_normal).substitute(mapping))
				h.write((h_noreturn if noreturn else h_normal).substitute(mapping))
			with open(sys.argv[1], "r") as b:
				for line in b:
					if line.strip() == "/* FOOTER */":
						break
				for line in b: # start at the footer
					h.write(line)
