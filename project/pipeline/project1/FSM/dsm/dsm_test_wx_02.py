import wx
import DecoratorStateMachine as dsm


class MyFrame(wx.Frame, dsm.ContextBase):
    dtable = dsm.TransitionTable('dstate')

    def __init__(self):
        self.dtable.initialize(self)

        wx.Frame.__init__(self, None, -1, "My Frame", size=(410, 250))
        font = wx.Font(11, wx.SWISS, wx.NORMAL, wx.BOLD, False, "Verdana")
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
        print "Shouldn't get here. Should call some state's onEnter function instead."

    @dsm.transition(dtable)
    def onToggleDoor(self, event): pass

    @dsm.event(dtable)
    def onInit(self):
        self.onEnter()  # calls onEnter for current dtable/dstate state

    @dsm.event(dtable)
    def onLightOn(self, event): pass

    @dsm.event(dtable)
    def onOpenDrawer(self, event): pass

    @dsm.event(dtable)
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


class DoorClosed(DoorOpen):
    doorLabel = "Open Door"
    xtable = dsm.TransitionTable('pstate')

    def onEnter(self):
        # Check self's class and return if it's not DoorClosed.
        # otherwise if one of the xtable substates hasn't defined 'onEnter', we
        # could go into infinite recursion.
        if self.__class__.__name__ != "MyFrame_DoorClosed":
            return
        DoorOpen.onEnter(self)
        self.xtable.initialize(self)
        self.doEnter()

    @dsm.event(xtable)
    def doEnter(self):
        self.onEnter()

    @dsm.transition(xtable)
    def onLightOn(self, event): pass

    @dsm.transition(xtable)
    def onOpenDrawer(self, event): pass

    @dsm.transition(xtable)
    def onClosePanel(self, event): pass


MyFrame.dtable.nextStates(DoorOpen, (DoorClosed,))
MyFrame.dtable.nextStates(DoorClosed, (DoorOpen,))
MyFrame.dtable.initialstate = DoorOpen


class Active(DoorClosed):
    def onEnter(self):
        print self.pstate.name()


class LightOn(Active):
    pass


class DrawerOpen(Active):
    pass


class Idle(Active):
    pass


class Unlocked(Active):
    def onEnter(self):
        print self.pstate.name()
        self.btnPanel.Enable()
        self.btnDoor.Disable()
        self.textArea.SetLabel("Unlocked")

    def onLeave(self):
        self.textArea.SetLabel("Locked")
        self.btnPanel.Disable()
        self.btnDoor.Enable()


DoorClosed.xtable.nextStates(Active, (LightOn, DrawerOpen, None))
DoorClosed.xtable.nextStates(LightOn, (None, Unlocked, None))
DoorClosed.xtable.nextStates(DrawerOpen, (Unlocked, None, None))
DoorClosed.xtable.nextStates(Unlocked, (None, None, Idle))
DoorClosed.xtable.nextStates(Idle, (None, None, None))
DoorClosed.xtable.initialstate = Active

if __name__ == '__main__':
    app = wx.PySimpleApp()
    frame = MyFrame()
    frame.Show(True)
    app.MainLoop()
