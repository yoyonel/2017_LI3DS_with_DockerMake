import types
import itertools

import logging

from functools import wraps

logging.basicConfig(
    filename="gf_info.txt",
    format="%(levelname)-10s %(message)s",
    level=logging.ERROR)


def truncated(alist, cmprsn):
    for x in alist:
        if x.__name__ == cmprsn: break
        yield x


class ContextBase(object):
    pass


class _StateVariable(object):
    """ Attribute of a class to maintain state .

    State Variable objects are instantiated indirectly via calls to the
    TransitionTable class's initialize method.  TransitionTable objects are created
    at the class level.
    """

    def __init__(self, transTable, context):
        """Constructor - set to initial state"""
        self.__current_state = transTable.initialstate
        self.__next_state = transTable.initialstate
        self.sTable = transTable
        self.__statestack = []
        self.__ctxClass = context.__class__

    def toNextState(self, context):
        """Transition to next state, if a next_state is differnt.

        In addition to the actual state transition, it invokes onLeave
        and onEnter methods as required.
        """
        if self.__next_state is not self.__current_state:
            cc = context.__class__
            tt_name = self.sTable.inst_state_name
            logging.debug("Transitioning to state %s" % self.__next_state.__name__)

            def callInState(methName, crnt_state):
                if hasattr(crnt_state, methName) or hasattr(context, methName):
                    nmro = [crnt_state, ]
                    nmro.extend(cc.__mro__)
                    psudoClassName = "%s_%s" % (cc.__name__, crnt_state.__name__)
                    stCls = type(psudoClassName, tuple(nmro), {})
                    context.__class__ = stCls
                    getattr(context, methName)()  # call the onEnter or onLeave method here
                    context.__class__ = cc

            callInState('onLeave', self.__current_state)
            self.__setState(context)
            callInState('onEnter', self.__current_state)

    def __setState(self, context):
        """low level funky called from toNextState"""
        cc = context.__class__
        mro = cc.__mro__
        if self.__current_state not in mro:
            self.__current_state = self.__next_state
            return

        logging.debug("Current state %s in mro" % self.__current_state.__name__)

        def f(anc):
            return self.__next_state if anc == self.__current_state else anc

        newmro = tuple(f(anc) for anc in cc.__mro__)
        tt_name = self.sTable.inst_state_name
        cls_name = "%s_%s" % (self.__ctxClass.__name__, self.__next_state.__name__)
        context.__class__ = type(cls_name, newmro, {})

    def pushState(self, newState, context=None):
        """PushState - allows going to another state with intent of returning
           to the current one."""
        self.__statestack.append(self._current_state)
        self.__next_state = newState
        if context:
            self.toNextState(context)

    def popState(self, context=None):
        """Pop back to the previously pushed state (pushState)"""
        self.__next_state = self.__statestack.pop()
        if (context):
            self.toNextState(context)

    def name(self):
        """Return name of current state"""
        return self.__current_state.__name__

    def setXition(self, func):
        """ Sets the state to transition to upon seeing a transtion event

        This method should only be called by the decorators impl'd in this module.
        """
        nxState = self.__current_state.nextStates[func.__name__]
        if nxState is not None:
            self.__next_state = nxState

    def getFunc(self, func, contxt):
        """Gets the state dependant action method, wrapped in a try-catch block.

        This method should only be called by the decorators impl'd in this module.
        """
        crnt = self.__current_state
        svar_name = self.sTable.inst_state_name
        svCtxt = self.__ctxClass

        cc = contxt.__class__
        pseudoclas = "%s_%s" % (cc.__name__, crnt.__name__)

        nmro = [crnt]
        lhead = itertools.takewhile(lambda x: x != svCtxt, crnt.__mro__)

        if svCtxt in cc.__mro__:
            ltail = itertools.dropwhile(lambda x: x != svCtxt, cc.__mro__)
        else:
            ltail = cc.__mro__
        nmro.extend(ltail)

        logging.debug("%s - %s - %s - [%s]\n" % (func.__name__, cc.__name__,
                                                 svar_name,
                                                 ", ".join(cls.__name__ for cls in truncated(nmro, 'TopLevelWindow'))))
        stCls = type(pseudoclas, tuple(nmro), {})

        contxt.__class__ = stCls

        try:
            funky = getattr(contxt, func.__name__)
        except:
            funky = None

        contxt.__class__ = cc  # revert...
        if funky is None:
            t = "'%s' has no attribute '%s' in state %s" % (self.name(),
                                                            func.__name__, crnt.__name__)
            raise NotImplementedError(t)

        # function with wrapping attribute means we've recursed all the way back
        #   to the context class and need to call the func as a default.
        if hasattr(funky, "wrapping") and (funky.wrapping == self.sTable.inst_state_name):
            def funcA(*args, **kwargs):
                return func(contxt, *args, **kwargs)

            funky = funcA

        def wrappd2(self, *args, **kwargs):
            # wrap in try - except in event that funky() does something funky
            try:
                self.__class__ = stCls
                retn = funky(*args, **kwargs)
            finally:
                self.__class__ = cc
            return retn

        return wrappd2


# -----------------------------------------------------------------------------
class TransitionTable(object):
    """Defines a state table for a state machine class

    A state table for a class is associated with the state variable in the instances
    of the class. The name of the state variable is given in the constructor to the
    StateTable object.  StateTable objects are attributes of state machine classes,
    not intances of the state machine class.   A state machine class can have more
    than one StateTable.
    """

    def __init__(self, stateVarblName):
        """Transition Table constructor - state varblName is name of associated
        instance state variable.  """
        self.inst_state_name = stateVarblName
        self.eventList = []
        self.initalState = None
        nextStates = {}

    def initialize(self, ctxt):
        """Create a new state variable in the context.  State variable refs this
        transition table."""

        ctxt.__dict__[self.inst_state_name] = _StateVariable(self, ctxt)

    def _addEventHandler(self, funcName):
        """Notifies the current object of a metho that handles a transition.

        This is called by two of the decorators implemented below
        """
        self.eventList.append(funcName)

    def nextStates(self, subState, nslList):
        """Sets up transitions from the state specified by substate

        subState is one of the derived state classes, subclassed from the
        context state machine class. nslList is a list of states to which
        the context will transition upon the invocation of one of the
        transition methods.  'None' may be specified instead of an actual
        state if the context is to remain in the same state upon invocation
        of the corresponding method.
        """
        if len(nslList) != len(self.eventList):
            j = "Expected %s Got %s." % (len(self.eventList), len(nslList))
            raise RuntimeError("Wrong number of states in transition list.\n%s" % j)
        subState.nextStates = dict(zip(self.eventList, nslList))


# -----------------------------------------------------------------------------
def event(state_table):
    """Decorator for indicating an Event or 'Action' method.

    The decorator is applied to the methods of the state machine class to
    indicate that the method will invoke a state dependant behavior. States
    are implemented as subclasses of the context(state machine) class .
    """
    stVarName = state_table.inst_state_name

    def wrapper(func):
        @wraps(func)
        def objCall(self, *args, **kwargs):
            state_var = getattr(self, stVarName)
            rtn = state_var.getFunc(func, self)(self, *args, **kwargs)
            return rtn

        objCall.wrapping = stVarName
        return objCall

    return wrapper


def transition(state_table):
    """Decorator used to set up methods which cause transitions between states.

    The decorator is applied to methods of the context (state machine) class.
    Invoking the method may cause a transition to another state.  To define
    what the transitions are, the nextStates method of the TransitionTable class
    is used.
    """
    stVarName = state_table.inst_state_name

    def wrapper(func):
        state_table._addEventHandler(func.__name__)

        @wraps(func)
        def objCall(self, *args, **kwargs):
            state_var = getattr(self, stVarName)
            state_var.setXition(func)
            rtn = func(self, *args, **kwargs)
            state_var.toNextState(self)
            return rtn

        objCall.wrapping = stVarName
        return objCall

    return wrapper


def transitionevent(state_table):
    """A decorator which is essentially the combination of the above two.

    Can both invoke state dependent method and trigger a state
    transition.  Mostly equivalent to :
    @Transition(xitionTable)
    @Event(xitionTable)
    """
    stVarName = state_table.inst_state_name

    def wrapper(func):
        state_table._addEventHandler(func.__name__)

        @wraps(func)
        def objCall(self, *args, **kwargs):
            state_var = getattr(self, stVarName)
            state_var.setXition(func)
            rtn = state_var.getFunc(func, self)(self, *args, **kwargs)
            state_var.toNextState(self)
            return rtn

        objCall.wrapping = stVarName
        return objCall

    return wrapper
