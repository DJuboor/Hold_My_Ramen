%% Mouse Macro
clc ;clear all

%Percent of Human Error to add onto the True Values in the Data
E = .1

%Percent of Human Error to add into the Pauses between clicks
E_p = .15

Data = ImportMiniMouse('.csv');

%Delete any "Click Release" commands (Minimouse generates it and our program doesn't support)
[r,~] = size(Data);
i = 1;

while i <= r
    if findstr(Data{i,5},'Release') >= 1 
    Data(i,:) = [];
    i = i - 1;
    r = r - 1;
    end
    
    i = i + 1;
 end
 
 
% [row col] = find(Result==0)
% Result(row,:) = []


 timer = 1;
 while timer == 1

[num_of_commands,~] = size(Data);
 for i = 1 : num_of_commands
    Command = Data(i,5);
    data = Data(i,1:4);
    data = cell2mat(data);  % Makes the numerics in the cell usable in functions as integers (not cell types)
    data(4) = data(4) / 1000;  % Converts into seconds to deal with Pause function
 
 
 %If moving from one place to another, move in 1000 smaller steps (don't just jump instantly, people can't do that)    
        if i >= 2
            x_start = Data{i-1,2};         y_start = Data{i-1,3};
            x_stop = data(2)     ;         y_stop = data(3);
     
            x_step = (x_stop - x_start)/999;
            y_step = (y_stop - y_start)/999;
            
            x_path = x_start:x_step: x_stop;
            y_path = y_start:y_step:y_stop;
            
            %Move the mouse across the path
            if sum(x_path) ~= 0 &&  sum(y_path) ~= 0  %Just in case the mouse never actually moved between the last step and this one 
                for j = 1:999
                    mouseMove(x_path(j),y_path(j),E)
                end
            end
        else
            mouseMove(data(2),data(3),E)
        end
            
    
    %%%%%%%%%Right Click%%%%%%%%%%%
    if strcmp(Command,'Right Click Down') == 1
        RightClick()
        
        if i < num_of_commands
        time_raw = Data{i+1,4};
        time = time_raw / 1000;
        else
        time = Data{1,4} / 1000;
        end
        
        RandPause(time,E_p)
    end
    
    %%%%%%%%%%Left Click%%%%%%%%
    if strcmp(Command,'Left Click Down') == 1
        LeftClick()
        
        if i < num_of_commands
        time_raw = Data{i+1,4};
        time = time_raw / 1000;
        else
        time = Data{1,4} / 1000;
        end
        
        RandPause(time,E_p)
    end
    
    %%%%%%%%Key Presses%%%%%%%%
    if findstr(Command{1},'Keypress') == 1
        char_data = Command{1};
        char_data = char_data(10:end)
        char_input = upper(char_data);
        
        Keypress(char_input);
        
        if i < num_of_commands
        time_raw = Data{i+1,4};
        time = time_raw / 1000;
        else
        time = Data{1,4} / 1000;
        end
        
        RandPause(time,E_p)
    end
 end
 
 
 
 %Move back to the original position  
        if i == num_of_commands
            x_start = Data{i,2}       ;      y_start = Data{i,3};
            x_stop = Data{1,2}    ;      y_stop = Data{1,3};
            
            x_step = (x_stop - x_start)/999;
            y_step = (y_stop - y_start)/999;
            
            x_path = x_start:x_step: x_stop;
            y_path = y_start:y_step:y_stop;
            
            %Move mouse along the path
            for j = 1:999
                mouseMove(x_path(j),y_path(j),E)
            end
        end
        
        
 end