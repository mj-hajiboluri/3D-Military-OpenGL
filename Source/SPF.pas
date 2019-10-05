unit SPF; // setup pixel format

interface
uses	{ uses clause }
   Windows ;
var
   hrc: HGLRC;  // Permanent Rendering Context
procedure CleanUp(Handle: HDC); //Properly Kill The Window
procedure SetDCPixelFormat(Handle: HDC;ColorBits,DepthBufferBits:integer);

implementation

procedure CleanUp(Handle: HDC); //Properly Kill The Window
begin
  if hrc<> 0 then       //Is There A Rendering Context?
    begin
       //Are We Able To Release Dc and Rc contexts?
       if (not wglMakeCurrent(handle,0)) then
         MessageBox(0,'Release of DC and RC failed.'
                    ,' Shutdown Error',MB_OK or MB_ICONERROR);
      //Are We Able To Delete The Rc?
       if (not wglDeleteContext(hRc)) then
        begin
          MessageBox(0,'Release of Rendering Context failed.',
                       ' Shutdown Error',MB_OK or MB_ICONERROR);
          hRc:=0;   //Set Rc To Null
        end;
    end;
end;

procedure SetDCPixelFormat(Handle: HDC;ColorBits,DepthBufferBits:integer);
var
  pfd: TPixelFormatDescriptor;
  nPixelFormat: Integer;

begin
  FillChar(pfd, SizeOf(pfd), 0);

  with pfd do begin
    nSize     := sizeof(pfd);             // Size of this structure
    nVersion  := 1;                       // Version number
    dwFlags   := PFD_SUPPORT_OPENGL Or PFD_DRAW_TO_WINDOW
                 Or  PFD_TYPE_RGBA 
                 or PFD_DOUBLEBUFFER {to avoid flickering} ;   // Flags
    iPixelType:= PFD_TYPE_RGBA;           // RGBA pixel values
    cColorBits:= ColorBits;               // 24-bit color
    cDepthBits:= DepthBufferBits;         // 32-bit depth buffer
    iLayerType:= PFD_MAIN_PLANE;          // Layer type
  end;

  nPixelFormat := ChoosePixelFormat(Handle, @pfd);
  //Did We Find A Matching Pixelformat?
  if (nPixelFormat=0) then
    begin
    CleanUp(handle);                          //Reset The Display
      MessageBox(0,'Cant''t Find A Suitable PixelFormat.'
                      ,'Error',MB_OK or MB_ICONEXCLAMATION);
      Halt(1); { Halt right here! }
    end;

  //Are We Able To Set The Pixelformat?
  if (not SetPixelFormat(Handle, nPixelFormat, @pfd)) then
    begin
      CleanUp(handle);                          //Reset The Display
      MessageBox(0,'Cant''t set PixelFormat.'
              ,'Error',MB_OK or MB_ICONEXCLAMATION);
      Halt(1); { Halt right here! }
    end;

  hrc := wglCreateContext(Handle);
  if (hRc=0) then
    begin
    CleanUp(handle);                        //Reset The Display
      MessageBox(0,'Cant''t create a GL rendering context.'
                         ,'Error',MB_OK or MB_ICONEXCLAMATION);
      Halt(1); { Halt right here! }
    end;

  //Are We Able To Activate The Rendering Context?
  if (not wglMakeCurrent(Handle, hrc)) then
    begin
    CleanUp(handle);                      //Reset The Display
    MessageBox(0,'Cant''t activate the GL rendering context.'
                          ,'Error',MB_OK or MB_ICONEXCLAMATION);
      Halt(1); { Halt right here! }
    end;

end;

end.
