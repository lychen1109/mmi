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

% Last Modified by GUIDE v2.5 25-Sep-2011 10:55:25

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
handles.sigma=varargin{2};
handles.imageidx=1;
handles.MAX=size(handles.imagepairs,1);
redrawfig(handles);

%show images on the right
% namelist=get(handles.popupmenu1,'String');
% selected=get(handles.popupmenu1,'Value');
% dirname=namelist{selected};
% images=loadimg(dirname);
% handles.images=images;
% handles.showidx=1;
% handles.dists=distcalc(handles);
% [~,handles.sortidx]=sort(handles.dists);
% sortlist=get(handles.popupmenu2,'String');
% sortvalue=get(handles.popupmenu2,'Value');
% handles.by=sortlist{sortvalue};
% updaterightpan(handles);
clearrightpan(handles);


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
updatefig2(fig,img);

function updatefig2(fig,img)
%helper function to show img in fig handle
imagesc(img,'parent',fig,[0 255]);
colormap gray;
axis(fig,'image','off');


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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imagepairs{handles.imageidx,2}=get(handles.text12,'String');
guidata(hObject, handles);
redrawfig(handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imagepairs{handles.imageidx,2}=get(handles.text13,'String');
guidata(hObject, handles);
redrawfig(handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imagepairs{handles.imageidx,2}=get(handles.text14,'String');
guidata(hObject, handles);
redrawfig(handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imagepairs{handles.imageidx,2}=get(handles.text15,'String');
guidata(hObject, handles);
redrawfig(handles);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imagepairs{handles.imageidx,2}=get(handles.text16,'String');
guidata(hObject, handles);
redrawfig(handles);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imagepairs{handles.imageidx,2}=get(handles.text17,'String');
guidata(hObject, handles);
redrawfig(handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imagepairs{handles.imageidx,2}=get(handles.text18,'String');
guidata(hObject, handles);
redrawfig(handles);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imagepairs{handles.imageidx,2}=get(handles.text19,'String');
guidata(hObject, handles);
redrawfig(handles);

function updaterightpan(handles)
%update right panel
switch handles.by
    case 'by name'
        images=handles.images;
        dists=handles.dists;
        filenames=handles.filenames;
    case 'by distance'
        images=handles.images(handles.sortidx,:);
        dists=handles.dists(handles.sortidx);
        filenames=handles.filenames(handles.sortidx);
end

n_img=size(handles.images,1);
for i=1:8
    switch i
        case 1
            h=handles.axes3;
            h2=handles.text4;
            h3=handles.text12;
        case 2
            h=handles.axes4;
            h2=handles.text5;
            h3=handles.text13;
        case 3
            h=handles.axes5;
            h2=handles.text6;
            h3=handles.text14;
        case 4
            h=handles.axes6;
            h2=handles.text7;
            h3=handles.text15;
        case 5
            h=handles.axes7;
            h2=handles.text8;
            h3=handles.text16;
        case 6
            h=handles.axes8;
            h2=handles.text9;
            h3=handles.text17;
        case 7
            h=handles.axes9;
            h2=handles.text10;
            h3=handles.text18;
        case 8
            h=handles.axes10;
            h2=handles.text11;
            h3=handles.text19;
    end
    showidx=handles.showidx+i-1;
    if showidx<=n_img
        updatefig2(h,reshape(images(showidx,:),128,128));
        set(h2,'String',num2str(dists(showidx)));
        set(h3,'String',filenames{showidx});
    else
        updatefig(h,'');
        set(h2,'String','');
        set(h3,'String','');
    end
end
set(handles.text3,'String',[num2str(handles.showidx) ' - ' num2str(handles.showidx+7) ' of ' num2str(n_img)]);


function clearrightpan(handles)
%show blank right panel when first load GUI
for i=1:8
    switch i
        case 1
            h=handles.axes3;
            h2=handles.text4;
            h3=handles.text12;
        case 2
            h=handles.axes4;
            h2=handles.text5;
            h3=handles.text13;
        case 3
            h=handles.axes5;
            h2=handles.text6;
            h3=handles.text14;
        case 4
            h=handles.axes6;
            h2=handles.text7;
            h3=handles.text15;
        case 5
            h=handles.axes7;
            h2=handles.text8;
            h3=handles.text16;
        case 6
            h=handles.axes8;
            h2=handles.text9;
            h3=handles.text17;
        case 7
            h=handles.axes9;
            h2=handles.text10;
            h3=handles.text18;
        case 8
            h=handles.axes10;
            h2=handles.text11;
            h3=handles.text19;
    end    
    updatefig(h,'');
    set(h2,'String','');
    set(h3,'String','');
end
set(handles.text3,'String','');


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.showidx-8>0
    handles.showidx=handles.showidx-8;
    guidata(hObject, handles);
    updaterightpan(handles);
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n_img=size(handles.images,1);
if handles.showidx+8<=n_img
    handles.showidx=handles.showidx+8;
    guidata(hObject, handles);
    updaterightpan(handles);
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

namelist=get(handles.popupmenu1,'String');
selected=get(handles.popupmenu1,'Value');
dirname=namelist{selected};
[handles.images,handles.filenames]=loadimg(dirname);
handles.showidx=1;
handles.dists=distcalc(handles);

[~,handles.sortidx]=sort(handles.dists);
sortlist=get(handles.popupmenu2,'String');
sortvalue=get(handles.popupmenu2,'Value');
handles.by=sortlist{sortvalue};

updaterightpan(handles);
guidata(hObject, handles);


function [images,filenames]=loadimg(dirname)
%helper function for loading images in the given dirname

root='C:\data\ImSpliceDataset\';
files=dir([root dirname filesep '*.bmp']);
n_img=size(files,1);
images=zeros(n_img,128^2);
filenames=cell(n_img,1);
for i=1:n_img
    img=imread([root dirname filesep files(i).name]);
    img=double(img);
    images(i,:)=img(:)';
    filenames{i}=files(i).name;
end

function dists=distcalc(handles)
%calculate distance between images and target image

filename=handles.imagepairs{handles.imageidx,1};
simg=imread(name2path(filename));
simg=double(simg);
tm1=tpm1d(simg,4,0,0);

n_img=size(handles.images,1);
dists=zeros(n_img,1);
for i=1:n_img
    img=handles.images(i,:);
    img=reshape(img,128,128);
    tm2=tpm1d(img,4,0,0);
    dists(i)=mahsdistcalc(tm1,tm2,handles.sigma);
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.showidx=1;
sortlist=get(handles.popupmenu2,'String');
sortvalue=get(handles.popupmenu2,'Value');
handles.by=sortlist{sortvalue};
updaterightpan(handles);
guidata(hObject, handles);
