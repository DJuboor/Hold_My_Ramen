function LeftClick()
import java.awt.Robot; import java.awt.event.*;
mouse = Robot;
mouse.mousePress(InputEvent.BUTTON1_MASK);
E = 2;
time = 0.2;
y = Humanize(time,E);
pause(y)
mouse.mouseRelease(InputEvent.BUTTON1_MASK);