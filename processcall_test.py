from subprocess import Popen, PIPE, STDOUT

proc_call = Popen('ls', stdout=PIPE)
output = proc_call.communicate()
print output
