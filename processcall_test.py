from subprocess import Popen, PIPE, STDOUT
import json
p = Popen(['prolog', '-q', '-s', 'main.pl'], stdin=PIPE, stdout=PIPE, stderr=STDOUT)

output = p.communicate()
    
output_tokens = output[0].strip().split(' ')
grid_state = json.loads(output_tokens[0])
playable_grids = json.loads(output_tokens[1])
won_grids = json.loads(output_tokens[2])


print 'Output = ', output
