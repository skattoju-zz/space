#Abstract Observable
class Observable(list):
  
  def addObserver(self, observer)
    self.append(observer)
    
  def notifyObservers(self, event):
    for observer in self:
      observer.update(event)

#Abstract observer
class Observer(object):
  
  def __init__(self,name):
    self.name = name
    
  def update(self,event):
    sys.stdout.write('=== %s: "%s"\n' % (self.name, event))
    
      
#Inherit from abstract Observable
class Timer(Observable):

  def tick(self,event):
    # update time step
    self.notifyObservers(self,simulation_time)
    
class Events(Observable):
  
  def fire(self,event):
    # generate alarms
    self.notifyObservers(self,event_id)
  

#Inherit from abstract Observer
class Process(Observer):
  
  def update(self,event):
    # compute things
    # & output results