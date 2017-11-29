import DecoratorStateMachine as dsm


class StateContext(dsm.ContextBase):
    ttable = dsm.TransitionTable('myState')

    def __init__(self):
        self.ttable.initialize(self)

    @dsm.transitionevent(ttable)
    def writeName(self, name):
        pass


class StateA(StateContext):
    def writeName(self, name):
        print name.lower()


class StateB(StateContext):
    def writeName(self, name):
        print name.upper()


class StateC(StateB):
    pass


# Set up transition table to cause states totoggle
StateContext.ttable.nextStates(StateA, (StateB,))
StateContext.ttable.nextStates(StateB, (StateC,))
StateContext.ttable.nextStates(StateC, (StateA,))
StateContext.ttable.initialstate = StateA

if __name__ == '__main__':
    days = ("Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday", "Sunday")
    ctxt = StateContext()
    for day in days:
        ctxt.writeName(day)
    x = raw_input("done>")
