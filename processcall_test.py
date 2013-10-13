from subprocess import Popen, PIPE, STDOUT

proc_call = Popen(['prolog', '-q', '-s', 'test.pl'], stdout=PIPE, stderr=STDOUT)
output = proc_call.communicate(input='haha')

print '-'*80
print output[0].strip()
print '-'*80
