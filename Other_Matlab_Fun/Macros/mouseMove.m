function mouseMove(x,y, E)
% x,y have to be int class

if E > 0 && E < 100
x = Humanize(x,E);
y = Humanize(y,E);
end

import java.awt.Robot;
mouse=Robot;
mouse.mouseMove(x,y);