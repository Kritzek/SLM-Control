function varargout = SLM_Control_GUI(varargin)
% SLM_CONTROL_GUI MATLAB code for SLM_Control_GUI.fig
%      SLM_CONTROL_GUI, by itself, creates a new SLM_CONTROL_GUI or raises the existing
%      singleton*.
%
%      H = SLM_CONTROL_GUI returns the handle to a new SLM_CONTROL_GUI or the handle to
%      the existing singleton*.
%
%      SLM_CONTROL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLM_CONTROL_GUI.M with the given input arguments.
%
%      SLM_CONTROL_GUI('Property','Value',...) creates a new SLM_CONTROL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SLM_Control_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SLM_Control_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SLM_Control_GUI

% Last Modified by GUIDE v2.5 20-Oct-2017 12:23:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SLM_Control_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SLM_Control_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SLM_Control_GUI is made visible.
function SLM_Control_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SLM_Control_GUI (see VARARGIN)

if isempty(varargin)
SLMobh=CK_SLM_class(2);
else
SLMobh=CK_SLM_class(varargin{1});
end
mask=ones(SLMobh.screenheight,SLMobh.screenwidth);
SLMobh.apply_mask(mask);

% Choose default command line output for SLM_Control_GUI
handles.output = {SLMobh,hObject};
handles.slmob = SLMobh;
handles.mask = mask;

%Adjust Sliders to screen resolution
handles.VertLinePos.Min= 0;
handles.VertLinePos.Max= SLMobh.screenwidth;
handles.VertLinePos.Value =1;
handles.HorLinePos.Min = 0;
handles.HorLinePos.Max= SLMobh.screenheight;
handles.HorLinePos.Value =1;

%adjust colormap
colormap(handles.ShowMask,'gray');

%Report the SLM Status
handles.initstring=(['SLM resolution  ',num2str(SLMobh.screenwidth),'x', ...
    num2str(SLMobh.screenheight)]);
handles.SLMstat.String=handles.initstring;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SLM_Control_GUI wait for user response (see UIRESUME)
% uiwait(handles.mainGUI);


% --- Outputs from this function are returned to the command line.
function varargout = SLM_Control_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function VertLinePos_Callback(hObject, eventdata, handles)
% hObject    handle to VertLinePos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp(hObject.Value);
SLM_GUI_refresh(handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function VertLinePos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VertLinePos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function HorLinePos_Callback(hObject, eventdata, handles)
% hObject    handle to HorLinePos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SLM_GUI_refresh(handles);
%disp(hObject.Value)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function HorLinePos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HorLinePos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in VertLine.
function VertLine_Callback(hObject, eventdata, handles)
% hObject    handle to VertLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VertLine
SLM_GUI_refresh(handles);


% --- Executes on button press in HorLine.
function HorLine_Callback(hObject, eventdata, handles)
% hObject    handle to HorLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HorLine
SLM_GUI_refresh(handles);


% --- Executes on button press in ShowImage.
function ShowImage_Callback(hObject, eventdata, handles)
% hObject    handle to ShowImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowImage
SLM_GUI_refresh(handles)


function HLineThick_Callback(hObject, eventdata, handles)
% hObject    handle to HLineThick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try val=str2num(hObject.String); end
if ~isempty(val)
    hObject.Value=val;
end
SLM_GUI_refresh(handles);


% Hints: get(hObject,'String') returns contents of HLineThick as text
%        str2double(get(hObject,'String')) returns contents of HLineThick as a double


% --- Executes during object creation, after setting all properties.
function HLineThick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HLineThick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VLineThick_Callback(hObject, eventdata, handles)
% hObject    handle to VLineThick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VLineThick as text
%        str2double(get(hObject,'String')) returns contents of VLineThick as a double
try val=str2num(hObject.String); end
if ~isempty(val)
    hObject.Value=val;
end
SLM_GUI_refresh(handles);



% --- Executes during object creation, after setting all properties.
function VLineThick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VLineThick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when user attempts to close mainGUI.
function mainGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(handles.slmob);
delete(hObject);

function SLM_GUI_refresh(handles)
    hpos=handles.HorLinePos.Value;
    hthick=handles.HLineThick.Value;
    vpos=handles.VertLinePos.Value;
    vthick=handles.VLineThick.Value;
    
    if ~(handles.VertLine.Value) 
        vpos=0;
    end
    if ~(handles.HorLine.Value) 
        hpos=0;
    end
    
    [handles.mask statstring]=handles.slmob.apply_line_mask(hpos,hthick,vpos,vthick);
    %handles.mask(1,:)
    if ~(handles.ShowImage.Value)
        imagesc(flipud(handles.mask));
    else
        image(handles.slmob.imgdat);
    end
    
    handles.SLMstat.String=[handles.initstring  char(10) statstring];
    guidata(handles.mainGUI,handles);
    
  
    
 
