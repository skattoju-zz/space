import sys
import time

class Jobs:
  
  def __init__(self, id, scheduled_time, execution_time, repeat = 1, period = 0, enabled = 1):
    self.id = id
    self.sched_time = scheduled_time
    self.exec_duration = execution_time
    self.repeat = repeat
    self.period = period
    self.enabled = enabled

  def execute(self,current_time):
    sys.stdout.write('event id : %s executing at %s\n' % (self.id,time.asctime(time.localtime(current_time))))
    fh = open('uplink.dat', 'a')
    fh.write('event id : %s executing at %s\n' % (self.id,time.asctime(time.localtime(current_time))))
    fh.close()

    