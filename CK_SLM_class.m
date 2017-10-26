classdef CK_SLM_class < handle
    %Controls the output to another screen like SLMs and can draw lines
    %Is/inherits from handle class because that's my typical obj behavior
    
    properties
%         fighandle
%         axhandle
        screennumber
        frame_java=[];
        gds=[];
        screenwidth
        screenheight
        icon_java        
        mask
        imgdat
        levelmin=0.535;
        levelmax=0.98;              
    end
    
    methods
        %Initializes the full screen window on window "screennumber"
        function obj=CK_SLM_class(screennumber)
            
            %Get screen devices with JAVA and create initial image
            %accordingly to size
            if nargin ==0 
                screennumber=1;
            end
            obj.screennumber=screennumber;
            ge = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment();
            obj.gds = ge.getScreenDevices();
            obj.screenheight = obj.gds(obj.screennumber).getDisplayMode().getHeight();
            obj.screenwidth = obj.gds(obj.screennumber).getDisplayMode().getWidth();
            obj.imgdat=uint8(repmat(ones(obj.screenheight,obj.screenwidth)*255,1,1,3));            
            
            %Create a JAVA swing JFrame to be displayed in FullScreen
            obj.frame_java = javax.swing.JFrame(obj.gds(obj.screennumber).getDefaultConfiguration());
            obj.frame_java.setUndecorated(true);
            obj.icon_java = javax.swing.ImageIcon(im2java(obj.imgdat)); 
            label = javax.swing.JLabel(obj.icon_java); 
            obj.frame_java.getContentPane.add(label);
            obj.gds(obj.screennumber).setFullScreenWindow(obj.frame_java);
            
            %This is very bad but the only way I see right now.
            %I'm first disposing the frame and then use pack/repaint/show
            %without regard of previously disposing. It should be followed
            %by frame_java=[] and the handle should not be used after
            %However the fullscreen window beeing created is resilient to
            %focus change, is always on top and can not be moved.
            %Some Window managing is probably killed by the use of dispose
            %Still closes when dispose is executed again.
            % Technically this is a JAVA bug that may be fixed in the
            % future. Works in 
            %Java 1.7.0_60-b19 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode
            obj.frame_java.dispose;           
            obj.icon_java.setImage(im2java(obj.imgdat));
            obj.frame_java.pack;
            obj.frame_java.repaint;
            obj.frame_java.show;                     
        end
        
        %Simply display an image to the fullscreen figure
        function display_image(obj,imgdata)            
            ImgSize=size(imgdata);
            %obj.screenres
            if ImgSize(1)~=obj.screenheight||ImgSize(2)~=obj.screenwidth
            error('Image resolution does not match screen resolution');
            end
            
            obj.imgdat=imgdata;
            obj.icon_java.setImage(im2java(imgdata));
            obj.frame_java.pack;
            obj.frame_java.repaint;
            obj.frame_java.show;
            %Matlab Figure
            %hImg=image(obj.imgdat,'Parent',obj.axhandle);
        end
        
        %Takes a mask of values between 0 - 1 of transmission and apply
        function apply_mask(obj,mask)
%              ImgSize=size(mask);
%             if ImgSize(1)~=obj.screenres(2)||ImgSize(2)~=obj.screenres(1)
%             error('Array size does not match SLM resolution');
%             end
            obj.mask=mask;
            phasemask = -(acosd((2*mask)-1)-180)/180;
            phasemask_shift=obj.levelmin + phasemask*(obj.levelmax-obj.levelmin);
            phasemask_shift=flipud(phasemask_shift);
            img=repmat(phasemask_shift,1,1,3);%[phasemask_shift phasemask_shift phasemask_shift];
            obj.display_image(uint8(255*img));
            %size(mask)
            %obj.screenres
        end 
        
        function [mask statstring]= apply_line_mask(obj,hlinepos,hlinewidth,vlinepos,vlinewidth)
            statstring='';
            hstart=round(max([hlinepos-hlinewidth/2,1]));
            hend=round(min([hlinepos+hlinewidth/2,obj.screenheight]));
            vstart=round(max([vlinepos-vlinewidth/2,1]));
            vend=round(min([vlinepos+vlinewidth/2,obj.screenwidth]));
            
            mask=ones(obj.screenheight,obj.screenwidth);
            
            if ~(hlinepos < 1)
                mask(hstart:hend,:)=0;
                %disp('Hor Line')
                statstring=['Horizontal Line from ', num2str(hstart),' to ', ...
                    num2str(hend),'. '] ;
            end
            
            if ~(vlinepos < 1)
                mask(:,vstart:vend)=0;
                statstring=[statstring,'Vertical Line from ', num2str(vstart),' to ', ...
                    num2str(vend), '. '] ;
                %disp('Vert Line')
            end
            
            
           obj.apply_mask(mask);            
        end
        
        function close_java_window(obj)
            try obj.frame_java.dispose(); end
        end
        
        function delete(obj)
            %DESTRUCTOR Same as close_java_window for now
            try obj.frame_java.dispose(); end
        end
        function imgdat = get_image(obj)
            imgdat=obj.imgdat;
        end
        
    end
    
end

