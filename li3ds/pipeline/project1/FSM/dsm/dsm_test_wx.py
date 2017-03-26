import wx
import DecoratorStateMachine as dsm


class MyFrame(wx.Frame, dsm.ContextBase):
    xtable = dsm.TransitionTable('pstate')
    dtable = dsm.TransitionTable('dstate')

    def __init__(self):
        self.xtable.initialize(self)
        self.dtable.initialize(self)

        wx.Frame.__init__(self, None, -1, "My Frame", size=(410, 250))
        family = wx.SWISS
        style = wx.NORMAL
        weight = wx.BOLD
        font = wx.Font(12, family, style, weight, False, "Verdana")
        self.SetFont(font)

        panel = wx.Panel(self, -1)

        self.btnDoor = self.makeButton(panel, "Door", (50, 20), self.onToggleDoor)
        self.btnLight = self.makeButton(panel, "Light", (180, 20), self.onLightOn)
        self.btnDrawer = self.makeButton(panel, "Drawer", (50, 60), self.onOpenDrawer)
        self.btnPanel = self.makeButton(panel, "Panel", (180, 60), self.onClosePanel)
        self.btnPanel.Disable()

        self.textArea = wx.StaticText(panel, -1, "Locked", pos=(50, 100), size=(100, 35))

        # onEnter called here would invoke MyFrame.onEnter (below)
        # call the current state's onEnter method indirectly through onInit()
        self.onInit()

    def onEnter(self):
        print "Shouldn't get here. Should call some state's onEnter functions instead."

    @dsm.transitionevent(dtable)
    def onToggleDoor(self, event): pass

    @dsm.event(dtable)
    def onInit(self):
        self.onEnter()  # calls onEnter for current dtable/dstate state

    @dsm.transition(xtable)
    def onOpenDoor(self): pass

    @dsm.transition(xtable)
    def onCloseDoor(self): pass

    @dsm.transition(xtable)
    def onLightOn(self, event): pass

    @dsm.transition(xtable)
    def onOpenDrawer(self, event): pass

    @dsm.transition(xtable)
    def onClosePanel(self, event): pass

    def makeButton(self, panel, label, positn, handler):
        button = wx.Button(panel, -1, label, pos=positn, size=(120, 35))
        self.Bind(wx.EVT_BUTTON, handler, button)
        return button


class DoorOpen(MyFrame):
    doorLabel = "Close Door"

    def onEnter(self):
        print self.dstate.name()
        self.btnDoor.SetLabel(self.doorLabel)

    def onToggleDoor(self, event):
        self.onCloseDoor()


class DoorClosed(DoorOpen):
    doorLabel = "Open Door"

    def onToggleDoor(self, event):
        self.onOpenDoor()


MyFrame.dtable.nextStates(DoorOpen, (DoorClosed,))
MyFrame.dtable.nextStates(DoorClosed, (DoorOpen,))
MyFrame.dtable.initialstate = DoorOpen


class Idle(MyFrame):
    """this is an initial state"""

    def onEnter(self):
        print self.pstate.name()


class Unlocked(Idle):
    def onEnter(self):
        print self.pstate.name()
        self.btnPanel.Enable()
        self.btnDoor.Disable()
        self.textArea.SetLabel("Unlocked")

    def onLeave(self):
        self.textArea.SetLabel("Locked")
        self.btnPanel.Disable()
        self.btnDoor.Enable()


class Active(Idle):
    pass


class LightOn(Idle):
    pass


class DrawerOpen(Idle):
    pass


MyFrame.xtable.nextStates(Idle, (Idle, Active, Idle, Idle, Idle))
MyFrame.xtable.nextStates(Active, (Idle, Active, LightOn, DrawerOpen, None))
MyFrame.xtable.nextStates(LightOn, (Idle, None, None, Unlocked, None))
MyFrame.xtable.nextStates(DrawerOpen, (Idle, None, Unlocked, None, None))
MyFrame.xtable.nextStates(Unlocked, (Idle, None, None, None, Idle))
MyFrame.xtable.initialstate = Idle

if __name__ == '__main__':
    app = wx.PySimpleApp()
    frame = MyFrame()
    frame.Show(True)
    app.MainLoop()
