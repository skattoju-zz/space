class Jobs(object):
  
  def __init__(id, scheduled_time, execution_time, repeat = 1, period = 0, enabled = 1):
    self.id = id
    self.sched_time = scheduled_time
    self.exec_duration = execution_time
    self.repeat = repeat
    self.enabled = enabled

  def execute(self):
    sys.stdout.write('event id : %s executing at %s\n' % (self.name, self.sched_time))

    