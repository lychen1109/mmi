function varargout = imagepairmng(varargin)
% IMAGEPAIRMNG M-file for imagepairmng.fig
%      IMAGEPAIRMNG, by itself, creates a new IMAGEPAIRMNG or raises the existing
%      singleton*.
%
%      H = IMAGEPAIRMNG returns the handle to a new IMAGEPAIRMNG or the handle to
%      the existing singleton*.
%
%      IMAGEPAIRMNG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEPAIRMNG.M with the given input arguments.
%
%      IMAGEPAIRMNG('Property','Value',...) creates a new IMAGEPAIRMNG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imagepairmng_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imagepairmng_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imagepairmng

% Last Modified by GUIDE v2.5 19-Sep-2011 16:30:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imagepairmng_OpeningFcn, ...
                   'gui_OutputFcn',  @imagepairmng_OutputFcn, ...
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


% --- Executes just before imagepairmng is made visible.
function imagepairmng_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imagepairmng (see VARARGIN)

handles.imagepairs=varargin{1};
handles.imageidx=1;
handles.MAX=size(handles.imagepairs,1);
redrawfig(handles);

% Choose default command line output for imagepairmng
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imagepairmng wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imagepairmng_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.imagepairs;

delete(hObject);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.imageidx>1
    handles.imageidx=handles.imageidx-1;
    redrawfig(handles);
    guidata(hObject, handles);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.imageidx<handles.MAX
    handles.imageidx=handles.imageidx+1;
    redrawfig(handles);
    guidata(hObject, handles);
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file2=get(handles.edit1,'String');
handles.imagepairs{handles.imageidx,2}=file2;
guidata(hObject, handles);
redrawfig(handles);


function updatefig(fig,filename)
%helper function to pudate axes

if isequal(filename,'')
    img=imread('C:\data\ImSpliceDataset\notfound.bmp');
else
    img=imread(name2path(filename));    
end
img=double(img);
imagesc(img,'parent',fig);
colormap gray;

function redrawfig(handles)
%redraw the whole UI according to current imageidx
set(handles.text1,'String',[num2str(handles.imageidx) 'th pair of images']);
file1=handles.imagepairs{handles.imageidx,1};
set(handles.text2,'String',file1);
updatefig(handles.axes1,file1);
file2=handles.imagepairs{handles.imageidx,2};
set(handles.edit1,'String',file2);
updatefig(handles.axes2,file2);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(hObject);

% Hint: delete(hObject) closes the figure
% delete(hObject);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename=get(handles.edit2,'String');
images=handles.imagepairs(:,1);
N=size(images,1);
idx=1;
idx2=0;
while idx<N+1
    if isequal(lower(filename),lower(images{idx}))
        idx2=idx;
        break;
    end
    idx=idx+1;
end

if idx2~=0
    handles.imageidx=idx2;
    guidata(hObject, handles);
    redrawfig(handles);
end
    


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit1,'String','');
