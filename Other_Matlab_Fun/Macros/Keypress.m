function Keypress( Letter)
% Input s is a string that corresponds with the second column in the table below. USE ALL CAPS. a and b are integers for a random pause range 
% This version uses the VK_xyz and eval approach.
import java.awt.Robot; import java.awt.event.*;
kb=Robot;

eval(['kb.keyPress(KeyEvent.VK_' Letter '); kb.keyRelease(KeyEvent.VK_' Letter ');']);
end

