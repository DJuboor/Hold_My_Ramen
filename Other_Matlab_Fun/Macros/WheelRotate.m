function WheelRotate(x)
% Input number of 'notches' to move the mouse wheel. Negative vlaues
% indicate movement up/away from the user, positive values indicate
% movement down/towards user.
import java.awt.Robot;
mouse=Robot;
mouse.mouseWheel(x);