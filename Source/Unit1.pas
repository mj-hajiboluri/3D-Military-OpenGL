unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Opengl,SPF, ExtCtrls, StdCtrls,math;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image29: TImage;
    Image30: TImage;
    Image31: TImage;
    Image32: TImage;
    Image33: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  hdc: Longint;
  rot_cube,rot_triangle: Single;
  v_parcham1,v_parcham2,v_parcham_flag1,v_parcham_flag2:single;
  v_heli1,v_heli2,sorate_charkhesh: Single;

  quadratic:GLUquadricObj;

  // baraye harakat
  z2,x3,y3,t,z,zy,x1,y1,y,z1,z3,balapayin,joloaghab: double;

  //baraye load kardane obj
  fileName : string;

  // baraye ijade nor az araye estefade mikonim.
  LightAmbient: array [0..3] of GLfloat = ( 0.5, 0.5, 0.5, 1.0 );
  LightDiffuse: array [0..3] of GLfloat = ( 1.0, 1.0, 1.0, 1.0 );
  LightPosition: array [0..3] of GLfloat = ( -6.0, 5.0, 4.0, 1.0 );
  LightPosition1: array [0..3] of GLfloat = ( -6.0, 5.0, 4.0, 1.0 );

  spotdir: array [0..2] of glfloat = (0,-1,0);
  spotdir1: array [0..2] of glfloat = (0,0,-1);
  // baraye ijad baft az yek araye estefade mikonim
  i:integer;
  texture: array [0..50] of GLuint;

  // moteghayer haye marbot be list namayeshi
  // har sheyi ke dar list namayeshi hast niaz
  // be yek shenase darad ke dar inja tarif mishavad
  // va az noe meghdare adadi GLuint mibashad
  fWidth,fHeight,dorbin_az_bala: integer;


  mosalas: GLuint;






implementation

{$R *.dfm}
//---------------------
//   farakhani zir barnamehaye ijade baft
//=====================
procedure glGenTextures(n: GLsizei;
         var textures: GLuint); stdcall; external opengl32;
procedure glBindTexture(target: GLenum;
         texture: GLuint); stdcall; external opengl32;
function gluBuild2DMipmaps(target: GLenum;
            components, width, height: GLint;
            format,atype: GLenum;
            Data: Pointer): GLint; stdcall; external glu32;

procedure getRGB(num : Longint; var r,g,b : Integer);
begin
      b := trunc((num And 16711680)/ 65536);
      g := trunc((num And 65280)/ 256);
      r := num And 255 ;
end;

procedure LoadGLTextures (pictoload : TImage);
var
    x,y : Longint;
    c,mapwidth,mapheight : Longint;
    red,green,blue : Integer;
    texture1:array[0..127,0..127,0..2] of GLubyte;
begin

    pictoload.AutoSize:= true;
    mapheight:=pictoload.Height;
    mapwidth:=pictoload.Width;

    for x := 0 to mapwidth-1 do
      for y := 0 to mapheight-1 do
        begin
          c := ColorToRGB(pictoload.Canvas.Pixels[x,y]);
          getRGB(c,red,green,blue);
          texture1[x,mapheight -y -1,0]:=red;
          texture1[x,mapheight -y -1,1]:=green;
          texture1[x,mapheight -y -1,2]:=blue;
        end;

    pictoload.Visible:=false;

    glGenTextures(3, texture[i]);
    glBindTexture(GL_TEXTURE_2D, texture[i]);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,
             GL_LINEAR_MIPMAP_NEAREST);
	gluBuild2DMipmaps(GL_TEXTURE_2D, 3, mapwidth, mapheight,
                GL_RGB, GL_UNSIGNED_BYTE, @texture1);
end;


//-------------------------




//-------------------------


procedure cube(x:Single; y:Single; z:Single; coord1:Integer; coord2:integer; tex:Integer);
begin
       glBindTexture(GL_TEXTURE_2D,texture[tex]);
       glBegin(GL_QUADS);
         //front
         glColor3f(1,1,1);
            glNormal3f(0,0,-1);
            glTexCoord2f(0,0);  glVertex3f(0,0,0);
            glTexCoord2f(coord1,0);  glVertex3f(0,y,0);
            glTexCoord2f(coord1,coord2);  glVertex3f(x,y,0);
            glTexCoord2f(0,coord2);  glVertex3f(x,0,0);
        //back
            //glColor3f(0.8,0,0);
            glNormal3f(0,0,1);
            glTexCoord2f(0,0); glVertex3f(0,0,-z);
            glTexCoord2f(coord1,0); glVertex3f(0,y,-z);
            glTexCoord2f(coord1,coord2); glVertex3f(x,y,-z);
            glTexCoord2f(0,coord2); glVertex3f(x,0,-z);
        //right
            //glColor3f(0.7,0,0);
            glNormal3f(1,0,0);
            glTexCoord2f(coord1,0); glVertex3f(x,y,0 );
            glTexCoord2f(coord1,coord2); glVertex3f(x,y,-z );
            glTexCoord2f(0,coord2); glVertex3f(x,0,-z );
            glTexCoord2f(0,0); glVertex3f(x,0,0 );
       //left
            //glColor3f(0.6,0,0);
            glNormal3f(-1,0,0);
            glTexCoord2f(coord1,0); glVertex3f(0,y,0 );
            glTexCoord2f(coord1,coord2); glVertex3f(0,y,-z );
            glTexCoord2f(0,coord2); glVertex3f(0,0,-z );
            glTexCoord2f(0,0); glVertex3f(0,0,0 );
       //top
            //glColor3f(0.5,0,0);
            glNormal3f(0,1,0);
            glTexCoord2f(0,0); glVertex3f(0,y,0 );
            glTexCoord2f(coord1,0); glVertex3f(0,y,-z );
            glTexCoord2f(coord1,coord2); glVertex3f(x,y,-z );
            glTexCoord2f(0,coord2); glVertex3f(x,y,0 );
        //down
            //glColor3f(0.4,0,0);
            glNormal3f(0,-1,0);
            glTexCoord2f(0,0); glVertex3f(0,0,0 );
            glTexCoord2f(coord1,0); glVertex3f(0,0,-z );
            glTexCoord2f(coord1,coord2); glVertex3f(x,0,-z );
            glTexCoord2f(0,coord2); glVertex3f(x,0,0 );

       glEnd;

end;

procedure cube1(x:Single; y:Single; z:Single; coord1:Integer; coord2:integer; tex:Integer);
begin
       glBindTexture(GL_TEXTURE_2D,texture[tex]);
       glBegin(GL_QUADS);
         //front
         glColor3f(1,1,1);
            glNormal3f(0,0,-1);
            glTexCoord2f(0,0);  glVertex3f(0,0,0);
            glTexCoord2f(coord1,0);  glVertex3f(0,y,0);
            glTexCoord2f(coord1,coord2);  glVertex3f(x,y,0);
            glTexCoord2f(0,coord2);  glVertex3f(x,0,0);
        //back
            //glColor3f(0.8,0,0);
            glNormal3f(0,0,1);
            {glTexCoord2f(0,0);} glVertex3f(0,0,-z);
            {glTexCoord2f(coord1,0);} glVertex3f(0,y,-z);
            {glTexCoord2f(coord1,coord2);} glVertex3f(x,y,-z);
            {glTexCoord2f(0,coord2);} glVertex3f(x,0,-z);
        //right
            //glColor3f(0.7,0,0);
            glNormal3f(1,0,0);
            {glTexCoord2f(coord1,0);} glVertex3f(x,y,0 );
            {glTexCoord2f(coord1,coord2);} glVertex3f(x,y,-z );
            {glTexCoord2f(0,coord2);} glVertex3f(x,0,-z );
            {glTexCoord2f(0,0);} glVertex3f(x,0,0 );
       //left
            //glColor3f(0.6,0,0);
            glNormal3f(-1,0,0);
            {glTexCoord2f(coord1,0);} glVertex3f(0,y,0 );
            {glTexCoord2f(coord1,coord2);} glVertex3f(0,y,-z );
            {glTexCoord2f(0,coord2);} glVertex3f(0,0,-z );
            {glTexCoord2f(0,0);} glVertex3f(0,0,0 );
       //top
            //glColor3f(0.5,0,0);
            glNormal3f(0,1,0);
           { glTexCoord2f(0,0);} glVertex3f(0,y,0 );
            {glTexCoord2f(coord1,0);} glVertex3f(0,y,-z );
            {glTexCoord2f(coord1,coord2);} glVertex3f(x,y,-z );
            {glTexCoord2f(0,coord2);} glVertex3f(x,y,0 );
        //down
            //glColor3f(0.4,0,0);
            glNormal3f(0,-1,0);
            {glTexCoord2f(0,0);} glVertex3f(0,0,0 );
            {glTexCoord2f(coord1,0);} glVertex3f(0,0,-z );
            {glTexCoord2f(coord1,coord2);} glVertex3f(x,0,-z );
            {glTexCoord2f(0,coord2);} glVertex3f(x,0,0 );

       glEnd;

end;

procedure cube2(x:Single; y:Single; z:Single; coord1:Integer; coord2:integer; tex:Integer);
begin
      glBindTexture(GL_TEXTURE_2D,texture[tex]);
       glBegin(GL_QUADS);
         //front

            glNormal3f(0,0,-1);
            glTexCoord2f(0,0);  glVertex3f(0,0,0);
            glTexCoord2f(coord1,0);  glVertex3f(0,y,0);
            glTexCoord2f(coord1,coord2);  glVertex3f(x,y,0);
            glTexCoord2f(0,coord2);  glVertex3f(x,0,0);
        //back

            glNormal3f(0,0,1);
            glTexCoord2f(0,0); glVertex3f(0,0,-z);
            glTexCoord2f(coord1,0); glVertex3f(0,y,-z);
            glTexCoord2f(coord1,coord2); glVertex3f(x,y,-z);
            glTexCoord2f(0,coord2); glVertex3f(x,0,-z);
        //right

            glNormal3f(1,0,0);
            glTexCoord2f(coord1,0); glVertex3f(x,y,0 );
            glTexCoord2f(coord1,coord2); glVertex3f(x,y,-z );
            glTexCoord2f(0,coord2); glVertex3f(x,0,-z );
            glTexCoord2f(0,0); glVertex3f(x,0,0 );
       //left

            glNormal3f(-1,0,0);
            glTexCoord2f(coord1,0); glVertex3f(0,y,0 );
            glTexCoord2f(coord1,coord2); glVertex3f(0,y,-z );
            glTexCoord2f(0,coord2); glVertex3f(0,0,-z );
            glTexCoord2f(0,0); glVertex3f(0,0,0 );
       //top

            glNormal3f(0,1,0);
            glTexCoord2f(0,0); glVertex3f(0,y,0 );
            glTexCoord2f(coord1,0); glVertex3f(0,y,-z );
            glTexCoord2f(coord1,coord2); glVertex3f(x,y,-z );
            glTexCoord2f(0,coord2); glVertex3f(x,y,0 );
        //down

            glNormal3f(0,-1,0);
            glTexCoord2f(0,0); glVertex3f(0,0,0 );
            glTexCoord2f(coord1,0); glVertex3f(0,0,-z );
            glTexCoord2f(coord1,coord2); glVertex3f(x,0,-z );
            glTexCoord2f(0,coord2); glVertex3f(x,0,0 );

       glEnd;

end;
//=========================
//-----------------------
//      list namayeshi
//=======================
procedure BuildList;
begin

mosalas:=glGenLists(40);
glNewList(mosalas,GL_COMPILE);

       //glBindTexture(GL_TEXTURE_2D,texture[0]);
       glBegin(GL_TRIANGLES);
           glNormal3f(0,1,0);
       //front
           glColor3f(0,0.9,0);
           glTexCoord2f(0,1); glVertex3f(-2.5,-2.5,2.5);
           glTexCoord2f(1,1); glVertex3f(2.5,-2.5,2.5);
           glTexCoord2f(1,0); glVertex3f(0,2.5,0);
       //right
           glColor3f(0,0.8,0);
           glTexCoord2f(0,0); glVertex3f(2.5,-2.5,2.5);
           glTexCoord2f(0,1); glVertex3f(2.5,-2.5,-2.5);
           glTexCoord2f(1,1); glVertex3f(0,2.5,0);
       //back
           glColor3f(0,0.7,0);
           glVertex3f(2.5,-2.5,-2.5);
           glVertex3f(-2.5,-2.5,-2.5);
           glVertex3f(0,2.5,0);
       //payini
           glColor3f(0,0.6,0);
           glVertex3f(-2.5,-2.5,-2.5);
           glVertex3f(-2.5,-2.5,2.5);
           glVertex3f(0,2.5,0);

   glEnd;

glEndList;
//////////////////////new list////////////////


end;

//----------------------------------------
///-----------------------------------
////-----------------------------
procedure initGL;
begin
//glEnable(GL_NORMALIZE);
  // load kardane tasavir
    LoadGLTextures(Form1.Image1); i:=i+1;
    LoadGLTextures(form1.Image2); i:=i+1;
    LoadGLTextures(Form1.Image3); i:=i+1;
    LoadGLTextures(Form1.Image4); i:=i+1;
    LoadGLTextures(Form1.Image5); i:=i+1;
    LoadGLTextures(Form1.Image6); i:=i+1;
    LoadGLTextures(Form1.Image7); i:=i+1;
    LoadGLTextures(Form1.Image8); i:=i+1;
    LoadGLTextures(Form1.Image9); i:=i+1;
    LoadGLTextures(Form1.Image10); i:=i+1;
    LoadGLTextures(Form1.Image11); i:=i+1;
    LoadGLTextures(Form1.Image12); i:=i+1;
    LoadGLTextures(Form1.Image13); i:=i+1;
    LoadGLTextures(Form1.Image14); i:=i+1;
    LoadGLTextures(Form1.Image15); i:=i+1;
    LoadGLTextures(Form1.Image16); i:=i+1;
    LoadGLTextures(Form1.Image17); i:=i+1;
    LoadGLTextures(Form1.Image18); i:=i+1;
    LoadGLTextures(Form1.Image19); i:=i+1;
    LoadGLTextures(Form1.Image20); i:=i+1;
    LoadGLTextures(Form1.Image21); i:=i+1;
    LoadGLTextures(Form1.Image22); i:=i+1;
    LoadGLTextures(Form1.Image23); i:=i+1;
    LoadGLTextures(Form1.Image24); i:=i+1;
    LoadGLTextures(Form1.Image25); i:=i+1;
    LoadGLTextures(Form1.Image26); i:=i+1;
    LoadGLTextures(Form1.Image27); i:=i+1;
    LoadGLTextures(Form1.Image28); i:=i+1;
    LoadGLTextures(Form1.Image29); i:=i+1;
    LoadGLTextures(Form1.Image30); i:=i+1;
    LoadGLTextures(Form1.Image31); i:=i+1;
    LoadGLTextures(Form1.Image32); i:=i+1;
    LoadGLTextures(Form1.Image33); i:=i+1;

  // faal sazi ijade baft
    glEnable(GL_TEXTURE_2D);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);


  // farakhani list namayeshi
    BuildList;

    glShadeModel(GL_SMOOTH);
    glClearColor(0,0,0,0.5);
    glClearDepth(1);
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);

    quadratic:=gluNewQuadric();
    gluQuadricNormals(quadratic,GLU_SMOOTH);
    gluQuadricTexture(quadratic,GL_TRUE);

  // nor pardazi
    glEnable(GL_LIGHTING);
    glLightfv(GL_LIGHT0, GL_AMBIENT, @LightAmbient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, @LightDiffuse);
    glEnable(GL_LIGHT0);
    glEnable(GL_COLOR_MATERIAL);




end;

procedure DrawGLScene;
begin
   glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
   glLoadIdentity;
   gluLookAt(x3,3+z+0.75+balapayin+dorbin_az_bala,y3,x1+x3,3+z+0.75+balapayin,y1+y3,0,1,0);

   glPushMatrix;
     glLightfv(GL_LIGHT0,GL_POSITION,@LightPosition);
   glPopMatrix;

   glTranslatef(50,0,20);


 //zamin
     glPushMatrix;
      glTranslatef(-200,-0.1,200);
      cube(400,0.1,400,50,50,2);
     glPopMatrix;

 // aseman
      glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[32]);
        glColor3f(1,1,1);
        glRotatef(45,0,1,0);
        gluSphere(quadratic,350,25,25);
     glPopMatrix;
//////////////////////////////////////////
//////////////obj////////////////////////
/////////////////////////////////////////


/////////////sakhteman edari va parcham/////////////
////////////////////////////////////////////////////
glPushMatrix;
glTranslatef(150,0,-18);
glRotatef(-90,0,1,0);
//** sakhtemane edari
glPushMatrix;

    //robero
    glPushMatrix;
        glTranslatef(0,0,0);
        cube1(15,12,0.3,2,2,20);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(25,0,0);
        cube1(15,12,0.3,2,2,20);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(15,6,0);
        cube1(10,6,0.3,1,1,20);
    glPopMatrix;
    //posht
    glPushMatrix;
        glTranslatef(0,0,-15);
        cube(40,12,0.3,1,1,26);
    glPopMatrix;
    //pahin
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(40,0.3,15,8,8,15);
    glPopMatrix;
    //bala
    glPushMatrix;
        glTranslatef(0,12,0);
        cube(40,0.3,15,1,1,26);
    glPopMatrix;
    //left
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.3,12,15,1,1,26);
    glPopMatrix;
    //right
    glPushMatrix;
        glTranslatef(40,0,0);
        cube(0.3,12,15,1,1,26);
    glPopMatrix;
    //door
    glPushMatrix;
        glTranslatef(15,0,0);
        glRotatef(-70,0,1,0);
        cube(5,6,0.3,1,1,27);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(25,0,0);
        glRotatef(70,0,1,0);
        cube(-5,6,0.3,1,1,27);
    glPopMatrix;
    
    //sakhteman balayi

    glPushMatrix;
        glTranslatef(10,12,-5);
        cube1(20,6,10,1,2,20);
    glPopMatrix;

glPopMatrix;

//**
//mizo sandali
glPushMatrix;
glTranslatef(16,0,-12);
glRotatef(-90,0,1,0);
//** sandali

    glPushMatrix;
    glTranslatef(-1,0,-0.75);

        glPushMatrix;
        glTranslatef(0,1.2,0);
        cube(1.5,0.16,1.5,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.1,2.7,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.4,0,0);
        cube(0.1,1.2,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-1.4);
        cube(0.1,2.7,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.4,0,-1.4);
        cube(0.1,1.2,0.1,1,1,10);
        glPopMatrix;

        /////
        glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.1,0.5,1.5,1,1,10);
        glPopMatrix;

    glPopMatrix;

//**

//** miz

    glPushMatrix;

        glPushMatrix;
        glTranslatef(0,2,0);
        cube(2,0.2,3,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

    glPopMatrix;
//**
glPopMatrix;

//mizo sandali 1
glPushMatrix;
glTranslatef(20,0,-12);
glRotatef(-90,0,1,0);
//** sandali

    glPushMatrix;
    glTranslatef(-1,0,-0.75);

        glPushMatrix;
        glTranslatef(0,1.2,0);
        cube(1.5,0.16,1.5,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.1,2.7,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.4,0,0);
        cube(0.1,1.2,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-1.4);
        cube(0.1,2.7,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.4,0,-1.4);
        cube(0.1,1.2,0.1,1,1,10);
        glPopMatrix;

        /////
        glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.1,0.5,1.5,1,1,10);
        glPopMatrix;

    glPopMatrix;

//**

//** miz

    glPushMatrix;

        glPushMatrix;
        glTranslatef(0,2,0);
        cube(2,0.2,3,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

    glPopMatrix;
//**
glPopMatrix;
//**

//** kesho
glPushMatrix;
   glTranslatef(38,0,-6);
   glRotatef(-90,0,1,0);
   cube1(3,5,2,1,1,29);
glPopMatrix;
glPushMatrix;
   glTranslatef(38,0,-11);
   glRotatef(-90,0,1,0);
   cube1(3,5,2,1,1,29);
glPopMatrix;
//**

//** map
glPushMatrix;
   glTranslatef(17.5,4,-14.9);
   cube(5,5,0.1,1,1,28);
glPopMatrix;
//**

//aslahe
glPushMatrix;
glTranslatef(-0,0,-0);
glRotatef(90,0,1,0);
///////////////////
//** tofang arpiji
glPushMatrix;
glTranslatef(11.5,3,3);
glRotatef(-55,0,1,0);
glPushMatrix;
glRotatef(-90,1,0,0);

    glPushMatrix;
    glTranslatef(2.99,1,0);
    cube(0.05,0.8,0.8,1,1,7);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(-0.04,1,0);
    cube(0.05,0.8,0.8,1,1,7);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(3,0.8,0.8,1,1,4);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.68,0.65,-0.35);
    cube(0.18,0.4,0.09,1,1,4);
    glPopMatrix;

glPopMatrix;
glPopMatrix;
//**

//** tofang yozi
glPushMatrix;
glTranslatef(13,2.3,3.8);
glRotatef(120,0,1,0);
glPushMatrix;
glRotatef(-90,1,0,0);

    glPushMatrix;
    glTranslatef(-1.5,0.7,0);
    cube(1,0.53,0.12,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(-0.5,0.9,0);
    cube(0.5,0.33,0.12,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(1,0.23,0.12,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.25,0.52,0);
    cube(0.2,0.49,0.12,1,1,9);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(1,1.13,0);
    cube(1,0.1,0.12,1,1,4);
    glPopMatrix;

glPopMatrix;
glPopMatrix;
//**



//** tofang kolt
glPushMatrix;
glTranslatef(12,2.3,3.8);
glRotatef(120,0,1,0);
glPushMatrix;
glRotatef(-90,1,0,0);

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(1,0.18,0.09,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.08,0.65,0);
    glRotatef(-12,0,0,1);
    cube(0.18,0.4,0.09,1,1,9);
    glPopMatrix;

glPopMatrix;
glPopMatrix;

//**
//** miz 1

    glPushMatrix;
    glTranslatef(10,0,5);
        glPushMatrix;
        glTranslatef(0,2,0);
        cube(2,0.2,3,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

    glPopMatrix;
//**

//** miz 2

    glPushMatrix;
    glTranslatef(12,0,5);
        glPushMatrix;
        glTranslatef(0,2,0);
        cube(2,0.2,3,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

    glPopMatrix;
//**
/////////////////////////
glPopMatrix;

//** parcham

glPushMatrix;
glTranslatef(20,13,-6);
glRotatef(90,0,1,0);
    glPushMatrix;
    glTranslatef(0,7,0);
    glRotatef(90,0,1,0);
        glBindTexture(GL_TEXTURE_2D,texture[30]);
        glBegin(GL_QUADS);

            glTexCoord2f(0,0);  glVertex3f(0,0,0);
            glTexCoord2f(1,0);  glVertex3f(0,3,0);
            glTexCoord2f(1,1);  glVertex3f(2,3,v_parcham1);
            glTexCoord2f(0,1);  glVertex3f(2,0,v_parcham1);

            glTexCoord2f(0,0);  glVertex3f(2,0,v_parcham1);
            glTexCoord2f(1,0);  glVertex3f(2,3,v_parcham1);
            glTexCoord2f(1,1);  glVertex3f(4,3,v_parcham2);
            glTexCoord2f(0,1);  glVertex3f(4,0,v_parcham2);

            glTexCoord2f(0,0);  glVertex3f(4,0,v_parcham2);
            glTexCoord2f(1,0);  glVertex3f(4,3,v_parcham2);
            glTexCoord2f(1,1);  glVertex3f(6,3,v_parcham1);
            glTexCoord2f(0,1);  glVertex3f(6,0,v_parcham1);

        glEnd;
        glPopMatrix;

        glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[4]);
        glTranslatef(0,10,0);
        glRotatef(90,1,0,0);
        gluCylinder(quadratic,0.2,0.2,10,15,1);
        glPopMatrix;

glPopMatrix;
//**
glPopMatrix;
////////////////////////////////////////////////////
////////////////////////////////////////////////////

/////////////  kooooooooooh/////////////////////////
////////////////////////////////////////////////////

//** koh
glPushMatrix;
    glTranslatef(250,-40,0);
    glRotatef(90,1,0,1);
    cube(60,20,60,1,1,31);
glPopMatrix;
glPushMatrix;
    glTranslatef(250,-40,40);
    glRotatef(90,1,0,1);
    cube(60,20,60,1,1,31);
glPopMatrix;
glPushMatrix;
    glTranslatef(250,-40,-40);
    glRotatef(90,1,0,1);
    cube(60,20,60,1,1,31);
glPopMatrix;
glPushMatrix;
    glTranslatef(260,-100,-80);
    glRotatef(45,1,0,0.02);
    cube(20,150,150,1,1,31);
glPopMatrix;
glPushMatrix;
    glTranslatef(260,-100,30);
    glRotatef(45,1,0,0.2);
    cube(20,150,150,1,1,31);
glPopMatrix;
//**

////////////////////////////////////////////////////
////////////////////////////////////////////////////


/////////////  mohavate dor/////////////////////////
////////////////////////////////////////////////////

//** mohavate
glPushMatrix;

    glPushMatrix;
        glTranslatef(0,0,-8);
        cube(8,18,8,1,1,25);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(-1,18,-7);
        cube(10,3,10,1,1,25);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,0,16);
        cube(8,18,8,1,1,25);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(-1,18,17);
        cube(10,3,10,1,1,25);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(3,0,-16);
        cube(1,15,50,1,1,25);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(3,0,16);
        cube(1,15,-55,1,1,25);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(3,0,71);
        cube(170,15,1,1,1,25);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(3,0,-65);
        cube(170,15,1,1,1,25);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(172,0,71);
        cube(1,15,137,1,1,25);
    glPopMatrix;

glPopMatrix;
//**

////////////////////////////////////////////////////
////////////////////////////////////////////////////

/////////////  parcham   ///////////////////////////
////////////////////////////////////////////////////

//** parcham

glPushMatrix;
glTranslatef(120,0,1.5);
    glPushMatrix;
    glTranslatef(0,7.9,0);
    glRotatef(90,0,1,0);
        glBindTexture(GL_TEXTURE_2D,texture[30]);
        glBegin(GL_QUADS);

            glTexCoord2f(0,0);  glVertex3f(0,0,0);
            glTexCoord2f(1,0);  glVertex3f(0,3,0);
            glTexCoord2f(1,1);  glVertex3f(2,3,v_parcham1);
            glTexCoord2f(0,1);  glVertex3f(2,0,v_parcham1);

            glTexCoord2f(0,0);  glVertex3f(2,0,v_parcham1);
            glTexCoord2f(1,0);  glVertex3f(2,3,v_parcham1);
            glTexCoord2f(1,1);  glVertex3f(4,3,v_parcham2);
            glTexCoord2f(0,1);  glVertex3f(4,0,v_parcham2);

            glTexCoord2f(0,0);  glVertex3f(4,0,v_parcham2);
            glTexCoord2f(1,0);  glVertex3f(4,3,v_parcham2);
            glTexCoord2f(1,1);  glVertex3f(6,3,v_parcham1);
            glTexCoord2f(0,1);  glVertex3f(6,0,v_parcham1);

        glEnd;
        glPopMatrix;

        glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[4]);
        glTranslatef(0,10.9,0);
        glRotatef(90,1,0,0);
        gluCylinder(quadratic,0.2,0.2,10,15,1);
        glPopMatrix;

        glPushMatrix;
            glTranslatef(-5,0.6,9);
            cube(10,0.3,18,1,1,25);
            glTranslatef(-1,-0.3,0);
            cube(11,0.3,18,1,1,25);
            glTranslatef(-1,-0.3,0);
            cube(12,0.3,18,1,1,25);
        glPopMatrix;

glPopMatrix;

//**

////////////////////////////////////////////////////
////////////////////////////////////////////////////

//////////////// zamine tir andazi  ////////////////
////////////////////////////////////////////////////
glPushMatrix;
glTranslatef(98,0,-32);
glRotatef(90,0,1,0);
//** tofang arpiji
glPushMatrix;
glTranslatef(11.5,3,3);
glRotatef(-55,0,1,0);
glPushMatrix;
glRotatef(-90,1,0,0);

    glPushMatrix;
    glTranslatef(2.99,1,0);
    cube(0.05,0.8,0.8,1,1,7);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(-0.04,1,0);
    cube(0.05,0.8,0.8,1,1,7);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(3,0.8,0.8,1,1,4);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.68,0.65,-0.35);
    cube(0.18,0.4,0.09,1,1,4);
    glPopMatrix;

glPopMatrix;
glPopMatrix;
//**

//** tofang yozi
glPushMatrix;
glTranslatef(13,2.3,3.8);
glRotatef(120,0,1,0);
glPushMatrix;
glRotatef(-90,1,0,0);

    glPushMatrix;
    glTranslatef(-1.5,0.7,0);
    cube(1,0.53,0.12,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(-0.5,0.9,0);
    cube(0.5,0.33,0.12,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(1,0.23,0.12,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.25,0.52,0);
    cube(0.2,0.49,0.12,1,1,9);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(1,1.13,0);
    cube(1,0.1,0.12,1,1,4);
    glPopMatrix;

glPopMatrix;
glPopMatrix;
//**



//** tofang kolt
glPushMatrix;
glTranslatef(12,2.3,3.8);
glRotatef(120,0,1,0);
glPushMatrix;
glRotatef(-90,1,0,0);

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(1,0.18,0.09,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.08,0.65,0);
    glRotatef(-12,0,0,1);
    cube(0.18,0.4,0.09,1,1,9);
    glPopMatrix;

glPopMatrix;
glPopMatrix;

//**
//** miz 1

    glPushMatrix;
    glTranslatef(10,0,5);
        glPushMatrix;
        glTranslatef(0,2,0);
        cube(2,0.2,3,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

    glPopMatrix;
//**

//** miz 2

    glPushMatrix;
    glTranslatef(12,0,5);
        glPushMatrix;
        glTranslatef(0,2,0);
        cube(2,0.2,3,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

    glPopMatrix;
//**

//** zamine sheni tamrin
glPushMatrix;

    glPushMatrix;
        glTranslatef(0,0,0);
        cube(25,0.1,35,5,5,21);
    glPopMatrix;
    glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[22]);
        glTranslatef(5,0,-5);
        gluSphere(quadratic,2,6,9);
        glTranslatef(0,0,-8);
        gluSphere(quadratic,2,6,9);
        glTranslatef(0,0,-8);
        gluSphere(quadratic,2,6,9);
    glPopMatrix;
    glPushMatrix;
    glTranslatef(15,0,0);
        glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[22]);
        glTranslatef(5,0,-5);
        gluSphere(quadratic,2,6,9);
        glTranslatef(0,0,-8);
        gluSphere(quadratic,2,6,9);
        glTranslatef(0,0,-8);
        gluSphere(quadratic,2,6,9);
        glPopMatrix;
    glPopMatrix;

    //sibl
    glPushMatrix;
        glTranslatef(7,0,-35);
        cube1(3,3,0.2,1,1,23);
        glTranslatef(7,0,0);
        cube1(3,3,0.2,1,1,23);
    glPopMatrix;

glPopMatrix;
//**
glPopMatrix;
////////////////////////////////////////////////////
////////////////////////////////////////////////////

////////////////     tank   ////////////////////////
////////////////////////////////////////////////////
glPushMatrix;
//** tank 1

glPushMatrix;
glTranslatef(120,0,-25);
    glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[1]);
        glBegin(GL_QUADS);
            //right
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,-13);

            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,1);  glVertex3f(22,6,0);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);
         glEnd;
         glBindTexture(GL_TEXTURE_2D,texture[0]);
         glBegin(GL_QUADS);
            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,1);  glVertex3f(2,6,0);
            glTexCoord2f(0,1);  glVertex3f(2,0,0);



            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(22,0,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,1);  glVertex3f(24,4,0);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //left
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,0,-13);



            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(22,0,-13);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,-13);
        glEnd;
        glBindTexture(GL_TEXTURE_2D,texture[0]);
        glBegin(GL_QUADS);
            //jolo
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,1);  glVertex3f(0,4,-13);
            glTexCoord2f(0,1);  glVertex3f(0,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,6,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,1);  glVertex3f(0,2,-13);
            glTexCoord2f(0,1);  glVertex3f(0,2,0);
            //aghab
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(24,2,0);
            glTexCoord2f(1,0);  glVertex3f(24,2,-13);
            glTexCoord2f(1,1);  glVertex3f(22,0,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(24,4,0);
            glTexCoord2f(1,0);  glVertex3f(24,4,-13);
            glTexCoord2f(1,1);  glVertex3f(24,2,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //balla
            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,6,0);
        glEnd;
    glPopMatrix;
    //loleye top
    glPushMatrix;
        glPushMatrix;
            glTranslatef(8,6,-4);
            cube(5,3,5,1,1,0);
            glTranslatef(-1,0,1);
            cube(7,1,7,1,1,0);
        glPopMatrix;
        glPushMatrix;
            glBindTexture(GL_TEXTURE_2D,texture[0]);
            glTranslatef(-7.8,9.8,-6.5);
            glRotatef(90,0,1,-0.1);
            gluCylinder(quadratic,0.5,0.5,16,12,1);
        glPopMatrix;
    glPopMatrix;

glPopMatrix;

//**

//** tank 2

glPushMatrix;
glTranslatef(120,0,-45);
    glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[1]);
        glBegin(GL_QUADS);
            //right
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,-13);

            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,1);  glVertex3f(22,6,0);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);
         glEnd;
         glBindTexture(GL_TEXTURE_2D,texture[0]);
         glBegin(GL_QUADS);
            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,1);  glVertex3f(2,6,0);
            glTexCoord2f(0,1);  glVertex3f(2,0,0);



            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(22,0,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,1);  glVertex3f(24,4,0);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //left
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,0,-13);
            
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(22,0,-13);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,-13);
        glEnd;
        glBindTexture(GL_TEXTURE_2D,texture[0]);
        glBegin(GL_QUADS);
            //jolo
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,1);  glVertex3f(0,4,-13);
            glTexCoord2f(0,1);  glVertex3f(0,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,6,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,1);  glVertex3f(0,2,-13);
            glTexCoord2f(0,1);  glVertex3f(0,2,0);
            //aghab
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(24,2,0);
            glTexCoord2f(1,0);  glVertex3f(24,2,-13);
            glTexCoord2f(1,1);  glVertex3f(22,0,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(24,4,0);
            glTexCoord2f(1,0);  glVertex3f(24,4,-13);
            glTexCoord2f(1,1);  glVertex3f(24,2,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //balla
            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,6,0);
        glEnd;
    glPopMatrix;
    //loleye top
    glPushMatrix;
        glPushMatrix;
            glTranslatef(8,6,-4);
            cube(5,3,5,1,1,0);
            glTranslatef(-1,0,1);
            cube(7,1,7,1,1,0);
        glPopMatrix;
        glPushMatrix;
            glBindTexture(GL_TEXTURE_2D,texture[0]);
            glTranslatef(-7.8,9.8,-6.5);
            glRotatef(90,0,1,-0.1);
            gluCylinder(quadratic,0.5,0.5,16,12,1);
        glPopMatrix;
    glPopMatrix;

glPopMatrix;

//**

//** tank 3

glPushMatrix;
glTranslatef(42,0,-38);
glRotatef(180,0,1,0);
    glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[1]);
        glBegin(GL_QUADS);
            //right
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,-13);

            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,1);  glVertex3f(22,6,0);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);
         glEnd;
         glBindTexture(GL_TEXTURE_2D,texture[0]);
         glBegin(GL_QUADS);
            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,1);  glVertex3f(2,6,0);
            glTexCoord2f(0,1);  glVertex3f(2,0,0);



            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(22,0,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,1);  glVertex3f(24,4,0);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //left
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,0,-13);



            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(22,0,-13);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,-13);
        glEnd;
        glBindTexture(GL_TEXTURE_2D,texture[0]);
        glBegin(GL_QUADS);
            //jolo
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,1);  glVertex3f(0,4,-13);
            glTexCoord2f(0,1);  glVertex3f(0,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,6,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,1);  glVertex3f(0,2,-13);
            glTexCoord2f(0,1);  glVertex3f(0,2,0);
            //aghab
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(24,2,0);
            glTexCoord2f(1,0);  glVertex3f(24,2,-13);
            glTexCoord2f(1,1);  glVertex3f(22,0,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(24,4,0);
            glTexCoord2f(1,0);  glVertex3f(24,4,-13);
            glTexCoord2f(1,1);  glVertex3f(24,2,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //balla
            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,6,0);
        glEnd;
    glPopMatrix;
    //loleye top
    glPushMatrix;
        glPushMatrix;
            glTranslatef(8,6,-4);
            cube(5,3,5,1,1,0);
            glTranslatef(-1,0,1);
            cube(7,1,7,1,1,0);
        glPopMatrix;
        glPushMatrix;
            glBindTexture(GL_TEXTURE_2D,texture[0]);
            glTranslatef(-7.8,9.8,-6.5);
            glRotatef(90,0,1,-0.1);
            gluCylinder(quadratic,0.5,0.5,16,12,1);
        glPopMatrix;
    glPopMatrix;

glPopMatrix;

//**
//** tank 4

glPushMatrix;
glTranslatef(42,0,-58);
glRotatef(180,0,1,0);
    glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[1]);
        glBegin(GL_QUADS);
            //right
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,-13);

            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,1);  glVertex3f(22,6,0);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);
         glEnd;
         glBindTexture(GL_TEXTURE_2D,texture[0]);
         glBegin(GL_QUADS);
            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,1);  glVertex3f(2,6,0);
            glTexCoord2f(0,1);  glVertex3f(2,0,0);



            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(22,0,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,1);  glVertex3f(24,4,0);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //left
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,0,-13);



            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(22,0,-13);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,-13);
        glEnd;
        glBindTexture(GL_TEXTURE_2D,texture[0]);
        glBegin(GL_QUADS);
            //jolo
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,1);  glVertex3f(0,4,-13);
            glTexCoord2f(0,1);  glVertex3f(0,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,6,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,1);  glVertex3f(0,2,-13);
            glTexCoord2f(0,1);  glVertex3f(0,2,0);
            //aghab
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(24,2,0);
            glTexCoord2f(1,0);  glVertex3f(24,2,-13);
            glTexCoord2f(1,1);  glVertex3f(22,0,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(24,4,0);
            glTexCoord2f(1,0);  glVertex3f(24,4,-13);
            glTexCoord2f(1,1);  glVertex3f(24,2,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //balla
            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,6,0);
        glEnd;
    glPopMatrix;
    //loleye top
    glPushMatrix;
        glPushMatrix;
            glTranslatef(8,6,-4);
            cube(5,3,5,1,1,0);
            glTranslatef(-1,0,1);
            cube(7,1,7,1,1,0);
        glPopMatrix;
        glPushMatrix;
            glBindTexture(GL_TEXTURE_2D,texture[0]);
            glTranslatef(-7.8,9.8,-6.5);
            glRotatef(90,0,1,-0.1);
            gluCylinder(quadratic,0.5,0.5,16,12,1);
        glPopMatrix;
    glPopMatrix;

glPopMatrix;

//**

glPopMatrix;

////////////////////////////////////////////////////
////////////////////////////////////////////////////

////////////////helicopter va band  ////////////////
////////////////////////////////////////////////////
glPushMatrix;
glTranslatef(40,0,40);
glRotatef(-90,0,1,0);
//** heli coopter
glPushMatrix;
glTranslatef(0,0.2,0);
   glBindTexture(GL_TEXTURE_2D,texture[3]);
   glBegin(GL_QUADS);
      ////-------------right-----------////
      glColor3f(1,1,1);
      glTexCoord2f(0,0);  glVertex3f(0,2,0);
      glTexCoord2f(1,0);  glVertex3f(0,4,0);
      glTexCoord2f(1,1);  glVertex3f(2,4,2);
      glTexCoord2f(0,1);  glVertex3f(2,2,2);

      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(2,4,2);
      glTexCoord2f(1,0);  glVertex3f(2,6,0);
      glTexCoord2f(1,1);  glVertex3f(7,6,0);
      glTexCoord2f(0,1);  glVertex3f(7,4,2);

      glColor3f(0.9,0.9,0.9);
      glTexCoord2f(0,0);  glVertex3f(2,2,2);
      glTexCoord2f(1,0);  glVertex3f(2,4,2);
      glTexCoord2f(1,1);  glVertex3f(7,4,2);
      glTexCoord2f(0,1);  glVertex3f(7,2,2);

      glColor3f(0.5,0.5,0.5);
      glTexCoord2f(0,0);  glVertex3f(2,0,0);
      glTexCoord2f(1,0);  glVertex3f(2,2,2);
      glTexCoord2f(1,1);  glVertex3f(7,2,2);
      glTexCoord2f(0,1);  glVertex3f(7,0,0);

      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(7,4,2);
      glTexCoord2f(1,0);  glVertex3f(7,6,0);
      glTexCoord2f(1,1);  glVertex3f(10,6,0);
      glTexCoord2f(0,1);  glVertex3f(10,5,0);

      glColor3f(1,1,1);
      glTexCoord2f(0,0);  glVertex3f(7,2,2);
      glTexCoord2f(1,0);  glVertex3f(7,4,2);
      glTexCoord2f(1,1);  glVertex3f(10,5,0);
      glTexCoord2f(0,1);  glVertex3f(8.2,2,0);
      ////-------------left-----------////
      glColor3f(1,1,1);
      glTexCoord2f(0,0);  glVertex3f(0,2,-1);
      glTexCoord2f(1,0);  glVertex3f(0,4,-1);
      glTexCoord2f(1,1);  glVertex3f(2,4,-3);
      glTexCoord2f(0,1);  glVertex3f(2,2,-3);

      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(2,4,-3);
      glTexCoord2f(1,0);  glVertex3f(2,6,-1);
      glTexCoord2f(1,1);  glVertex3f(7,6,-1);
      glTexCoord2f(0,1);  glVertex3f(7,4,-3);

      glColor3f(0.9,0.9,0.9);
      glTexCoord2f(0,0);  glVertex3f(2,2,-3);
      glTexCoord2f(1,0);  glVertex3f(2,4,-3);
      glTexCoord2f(1,1);  glVertex3f(7,4,-3);
      glTexCoord2f(0,1);  glVertex3f(7,2,-3);

      glColor3f(0.5,0.5,0.5);
      glTexCoord2f(0,0);  glVertex3f(2,0,-1);
      glTexCoord2f(1,0);  glVertex3f(2,2,-3);
      glTexCoord2f(1,1);  glVertex3f(7,2,-3);
      glTexCoord2f(0,1);  glVertex3f(7,0,-1);

      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(7,4,-3);
      glTexCoord2f(1,0);  glVertex3f(7,6,-1);
      glTexCoord2f(1,1);  glVertex3f(10,6,-1);
      glTexCoord2f(0,1);  glVertex3f(10,5,-1);

      glColor3f(1,1,1);
      glTexCoord2f(0,0);  glVertex3f(7,2,-3);
      glTexCoord2f(1,0);  glVertex3f(7,4,-3);
      glTexCoord2f(1,1);  glVertex3f(10,5,-1);
      glTexCoord2f(0,1);  glVertex3f(8.2,2,-1);
      //-------------vasat-------------//
      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(2,0,0);
      glTexCoord2f(1,0);  glVertex3f(2,0,-1);
      glTexCoord2f(1,1);  glVertex3f(0,2,-1);
      glTexCoord2f(0,1);  glVertex3f(0,2,0);

      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(0,2,0);
      glTexCoord2f(1,0);  glVertex3f(0,2,-1);
      glTexCoord2f(1,1);  glVertex3f(0,4,-1);
      glTexCoord2f(0,1);  glVertex3f(0,4,0);



      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(2,6,0);
      glTexCoord2f(1,0);  glVertex3f(2,6,-1);
      glTexCoord2f(1,1);  glVertex3f(10,6,-1);
      glTexCoord2f(0,1);  glVertex3f(10,6,0);

      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(2,0,0);
      glTexCoord2f(1,0);  glVertex3f(2,0,-1);
      glTexCoord2f(1,1);  glVertex3f(7,0,-1);
      glTexCoord2f(0,1);  glVertex3f(7,0,0);

      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(7,0,0);
      glTexCoord2f(1,0);  glVertex3f(7,0,-1);
      glTexCoord2f(1,1);  glVertex3f(10,5,-1);
      glTexCoord2f(0,1);  glVertex3f(10,5,0);
   glEnd;

   glBindTexture(GL_TEXTURE_2D,texture[5]);
   glBegin(GL_QUADS);
   glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(0,4,0);
      glTexCoord2f(1,0);  glVertex3f(0,4,-1);
      glTexCoord2f(1,1);  glVertex3f(2,6,-1);
      glTexCoord2f(0,1);  glVertex3f(2,6,0);
   glEnd;
   //noghate mosalasi kar
   glBindTexture(GL_TEXTURE_2D,texture[5]);
   glBegin(GL_TRIANGLES);
      //------------right-----------//
      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(0,4,-1);
      glTexCoord2f(1,0);  glVertex3f(2,6,-1);
      glTexCoord2f(1,1);  glVertex3f(2,4,-3);

      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(0,4,0);
      glTexCoord2f(1,0);  glVertex3f(2,6,0);
      glTexCoord2f(1,1);  glVertex3f(2,4,2);
   glEnd;
   glBindTexture(GL_TEXTURE_2D,texture[3]);
   glBegin(GL_TRIANGLES);
      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(0,2,0);
      glTexCoord2f(1,0);  glVertex3f(2,2,2);
      glTexCoord2f(1,1);  glVertex3f(2,0,0);

      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(7,0,0);
      glTexCoord2f(1,0);  glVertex3f(8.2,2,0);
      glTexCoord2f(1,1);  glVertex3f(7,2,2);

      //------------left-----------//
      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(0,2,-1);
      glTexCoord2f(1,0);  glVertex3f(2,2,-3);
      glTexCoord2f(1,1);  glVertex3f(2,0,-1);

      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(7,0,-1);
      glTexCoord2f(1,0);  glVertex3f(8.2,2,-1);
      glTexCoord2f(1,1);  glVertex3f(7,2,-3);

   glEnd;
   // dom
   glPushMatrix;
      glTranslatef(10,5,0);
      cube(9,1,1,1,1,3);
      glTranslatef(8.5,-1,0);
      cube(0.3,3,0.2,1,1,6);
   glPopMatrix;
   //charkhe helikopter
   glPushMatrix;
   glPushMatrix;
   glTranslatef(1,0,1);
      glPushMatrix;
      cube(7,0.3,0.3,1,1,6);
      glTranslatef(1,0,0);
      cube(0.2,1,0.3,1,1,6);
      glTranslatef(4,0,0);
      cube(0.2,1,0.3,1,1,6);
      glPopMatrix;
   glPopMatrix;

   glPushMatrix;
   glTranslatef(1,0,-1.7);
      glPushMatrix;
      cube(7,0.3,0.3,1,1,6);
      glTranslatef(1,0,0);
      cube(0.2,1,0.3,1,1,6);
      glTranslatef(4,0,0);
      cube(0.2,1,0.3,1,1,6);
      glPopMatrix;
   glPopMatrix;
   glPopMatrix;

   // malakhe havapeyma
   glPushMatrix;
      glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[6]);
        glTranslatef(4,6.9,-0.5);
        glRotatef(90,1,0,0);
        gluCylinder(quadratic,0.3,0.3,0.9,9,1);
      glPopMatrix;

      glPushMatrix;
        glPushMatrix;
          glTranslatef(4,6.5,-0.5);
          glRotatef(v_heli1,0,1,0);
          cube(13,0.2,0.6,1,1,6);
        glPopMatrix;

        glPushMatrix;
          glTranslatef(4,6.5,-0.5);
          glRotatef(v_heli1,0,1,0);
          cube(-13,0.2,0.6,1,1,6);
        glPopMatrix;
      glPopMatrix;

   glPopMatrix;

glPopMatrix;
//**
//** bande helicopter
glPushMatrix;
    glPushMatrix;
      glTranslatef(-5,0,12);
      cube(25,0.2,25,1,1,24);
    glPopMatrix;
glPopMatrix;
//**
glPopMatrix;

////////////////////////////////////////////////////
////////////////////////////////////////////////////


////////////////sarbazkhune va takht 1////////////////
////////////////////////////////////////////////////
glPushMatrix;
glTranslatef(140,0,30);
glRotatef(180,0,1,0);
//** takhtsarbazi 1

glPushMatrix;
glTranslatef(8,0,-10);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 2

glPushMatrix;
glTranslatef(8,0,-20);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 3

glPushMatrix;
glTranslatef(8,0,-30);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 4

glPushMatrix;
glTranslatef(12,0,-7);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** takhtsarbazi 5

glPushMatrix;
glTranslatef(12,0,-17);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** takhtsarbazi 6

glPushMatrix;
glTranslatef(12,0,-27);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** sarbazkhune
glPushMatrix;

    //front
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(8,9,0.2,2,2,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(8,6,0);
        cube(4,3,0.2,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(12,0,0);
        cube(8,9,0.2,2,2,13);
    glPopMatrix;
    //posht
    glPushMatrix;
        glTranslatef(0,0,-35);
        cube(20,9,0.2,2,2,13);
    glPopMatrix;
    //right
   glPushMatrix;
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,6,0);
        cube(0.2,3,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.2,4,5,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-9);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-19);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-29);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;
   glPopMatrix;
   //left
   glPushMatrix;
   glTranslatef(20,0,0);
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,6,0);
        cube(0.2,3,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.2,4,5,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-9);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-19);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-29);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;
   glPopMatrix;
     //zamin
    glPushMatrix;
        glTranslatef(0.1,0,-0.1);
        cube(19.8,0.2,34.8,6,6,15);
    glPopMatrix;
    //saghf
    glPushMatrix;
        glTranslatef(0,9,0);
        cube(20,0.2,35,1,1,13);
    glPopMatrix;
    /////////////////
    //dar
    glPushMatrix;
        glTranslatef(8,0,0);
        glRotatef(80,0,1,0);
        cube(4,6,0.2,1,1,18);
    glPopMatrix;
    /////////////////
    //panjere right
    glPushMatrix;
      glPushMatrix;
        glTranslatef(0,2,-5);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-15);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-25);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;
    glPopMatrix;
    //panjere left
    glPushMatrix;
    glTranslatef(20,0,0);
      glPushMatrix;
        glTranslatef(0,2,-5);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-15);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-25);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;
    glPopMatrix;

glPopMatrix;
//**
glPopMatrix;

////////////////////////////////////////////////////
////////////////////////////////////////////////////

////////////////sarbazkhune va takht 2////////////////
////////////////////////////////////////////////////
glPushMatrix;
glTranslatef(110,0,30);
glRotatef(180,0,1,0);
//** takhtsarbazi 1

glPushMatrix;
glTranslatef(8,0,-10);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 2

glPushMatrix;
glTranslatef(8,0,-20);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 3

glPushMatrix;
glTranslatef(8,0,-30);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 4

glPushMatrix;
glTranslatef(12,0,-7);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** takhtsarbazi 5

glPushMatrix;
glTranslatef(12,0,-17);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** takhtsarbazi 6

glPushMatrix;
glTranslatef(12,0,-27);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** sarbazkhune
glPushMatrix;

    //front
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(8,9,0.2,2,2,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(8,6,0);
        cube(4,3,0.2,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(12,0,0);
        cube(8,9,0.2,2,2,13);
    glPopMatrix;
    //posht
    glPushMatrix;
        glTranslatef(0,0,-35);
        cube(20,9,0.2,2,2,13);
    glPopMatrix;
    //right
   glPushMatrix;
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,6,0);
        cube(0.2,3,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.2,4,5,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-9);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-19);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-29);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;
   glPopMatrix;
   //left
   glPushMatrix;
   glTranslatef(20,0,0);
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,6,0);
        cube(0.2,3,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.2,4,5,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-9);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-19);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-29);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;
   glPopMatrix;
     //zamin
    glPushMatrix;
        glTranslatef(0.1,0,-0.1);
        cube(19.8,0.2,34.8,6,6,15);
    glPopMatrix;
    //saghf
    glPushMatrix;
        glTranslatef(0,9,0);
        cube(20,0.2,35,1,1,13);
    glPopMatrix;
    /////////////////
    //dar
    glPushMatrix;
        glTranslatef(8,0,0);
        glRotatef(80,0,1,0);
        cube(4,6,0.2,1,1,18);
    glPopMatrix;
    /////////////////
    //panjere right
    glPushMatrix;
      glPushMatrix;
        glTranslatef(0,2,-5);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-15);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-25);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;
    glPopMatrix;
    //panjere left
    glPushMatrix;
    glTranslatef(20,0,0);
      glPushMatrix;
        glTranslatef(0,2,-5);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-15);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-25);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;
    glPopMatrix;

glPopMatrix;
//**
glPopMatrix;

////////////////////////////////////////////////////
////////////////////////////////////////////////////

////////////////sarbazkhune va takht 3////////////////
////////////////////////////////////////////////////
glPushMatrix;
glTranslatef(80,0,30);
glRotatef(180,0,1,0);
//** takhtsarbazi 1

glPushMatrix;
glTranslatef(8,0,-10);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 2

glPushMatrix;
glTranslatef(8,0,-20);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 3

glPushMatrix;
glTranslatef(8,0,-30);
glRotatef(-90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
//** takhtsarbazi 4

glPushMatrix;
glTranslatef(12,0,-7);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** takhtsarbazi 5

glPushMatrix;
glTranslatef(12,0,-17);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** takhtsarbazi 6

glPushMatrix;
glTranslatef(12,0,-27);
glRotatef(90,0,1,0);

        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**

//** sarbazkhune
glPushMatrix;

    //front
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(8,9,0.2,2,2,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(8,6,0);
        cube(4,3,0.2,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(12,0,0);
        cube(8,9,0.2,2,2,13);
    glPopMatrix;
    //posht
    glPushMatrix;
        glTranslatef(0,0,-35);
        cube(20,9,0.2,2,2,13);
    glPopMatrix;
    //right
   glPushMatrix;
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,6,0);
        cube(0.2,3,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.2,4,5,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-9);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-19);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-29);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;
   glPopMatrix;
   //left
   glPushMatrix;
   glTranslatef(20,0,0);
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,6,0);
        cube(0.2,3,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.2,4,5,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-9);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-19);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-29);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;
   glPopMatrix;
     //zamin
    glPushMatrix;
        glTranslatef(0.1,0,-0.1);
        cube(19.8,0.2,34.8,6,6,15);
    glPopMatrix;
    //saghf
    glPushMatrix;
        glTranslatef(0,9,0);
        cube(20,0.2,35,1,1,13);
    glPopMatrix;
    /////////////////
    //dar
    glPushMatrix;
        glTranslatef(8,0,0);
        glRotatef(80,0,1,0);
        cube(4,6,0.2,1,1,18);
    glPopMatrix;
    /////////////////
    //panjere right
    glPushMatrix;
      glPushMatrix;
        glTranslatef(0,2,-5);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-15);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-25);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;
    glPopMatrix;
    //panjere left
    glPushMatrix;
    glTranslatef(20,0,0);
      glPushMatrix;
        glTranslatef(0,2,-5);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-15);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-25);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;
    glPopMatrix;

glPopMatrix;
//**
glPopMatrix;

////////////////////////////////////////////////////
////////////////////////////////////////////////////

////////////////////enfejaaaaaaaar//////////////////
////////////////////////////////////////////////////
glPushMatrix;
glTranslatef(80,0,-44);
//** enfejar
     ////-----------dakheli
     glpushmatrix;
     glRotatef(rot_cube*80,0,1,0);
     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[16]);
        glColor4f(1,1,1,1-rot_triangle*0.6);
        glScalef(rot_cube*3,rot_cube*3,rot_cube*3);
        glBegin(GL_QUADS);
         glTexCoord2f(0,0);  glVertex3f(-1,0,0);
            glTexCoord2f(1,0);  glVertex3f(-1,1.0,0);
            glTexCoord2f(1,1);  glVertex3f(1,1.0,0);
            glTexCoord2f(0,1);  glVertex3f(1,0,0);
        glEnd;
     glPopMatrix;

     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[16]);
        glColor4f(1,1,1,1-rot_triangle*0.6);
        glRotatef(90,0,1,0);
        glScalef(rot_cube*2,rot_cube*2,rot_cube*2);
        glBegin(GL_QUADS);
         glTexCoord2f(0,0);  glVertex3f(-1,0,0);
            glTexCoord2f(1,0);  glVertex3f(-1,1.0,0);
            glTexCoord2f(1,1);  glVertex3f(1,1.0,0);
            glTexCoord2f(0,1);  glVertex3f(1,0,0);
        glEnd;
     glPopMatrix;

     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[16]);
        glColor4f(1,1,1,1-rot_triangle*0.6);
        glRotatef(135,0,1,0);
        glScalef(rot_cube*3.5,rot_cube*3.5,rot_cube*3.5);
        glBegin(GL_QUADS);
         glTexCoord2f(0,0);  glVertex3f(-1,0,0);
            glTexCoord2f(1,0);  glVertex3f(-1,1.0,0);
            glTexCoord2f(1,1);  glVertex3f(1,1.0,0);
            glTexCoord2f(0,1);  glVertex3f(1,0,0);
        glEnd;
     glPopMatrix;

     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[16]);
        glColor4f(1,1,1,1-rot_triangle*0.6);
        glRotatef(235,0,1,0);
        glScalef(rot_cube*2,rot_cube*2,rot_cube*2);
        glBegin(GL_QUADS);
         glTexCoord2f(0,0);  glVertex3f(-1,0,0);
            glTexCoord2f(1,0);  glVertex3f(-1,1.0,0);
            glTexCoord2f(1,1);  glVertex3f(1,1.0,0);
            glTexCoord2f(0,1);  glVertex3f(1,0,0);
        glEnd;
     glPopMatrix;
     glPopMatrix;
     //payane enfejar dakheli-------

     ////--------- bironi
     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[17]);
        glColor4f(1,1,1,1-(rot_triangle*0.6));
        glRotatef(rot_cube*40,1,1,1);
        glScalef(rot_cube,rot_cube,rot_cube);
        gluSphere(quadratic,5,25,25);
     glpopmatrix;
     //payane enfejar bironi --------
//**
glPopMatrix;
////////////////////////////////////////////////////
////////////////////////////////////////////////////
{
//** zamine sheni tamrin
glPushMatrix;

    glPushMatrix;
        glTranslatef(0,0,0);
        cube(25,0.1,35,5,5,21);
    glPopMatrix;
    glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[22]);
        glTranslatef(5,0,-5);
        gluSphere(quadratic,2,6,9);
        glTranslatef(0,0,-8);
        gluSphere(quadratic,2,6,9);
        glTranslatef(0,0,-8);
        gluSphere(quadratic,2,6,9);
    glPopMatrix;
    glPushMatrix;
    glTranslatef(15,0,0);
        glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[22]);
        glTranslatef(5,0,-5);
        gluSphere(quadratic,2,6,9);
        glTranslatef(0,0,-8);
        gluSphere(quadratic,2,6,9);
        glTranslatef(0,0,-8);
        gluSphere(quadratic,2,6,9);
        glPopMatrix;
    glPopMatrix;

    //sibl
    glPushMatrix;
        glTranslatef(7,0,-35);
        cube1(3,3,0.2,1,1,23);
        glTranslatef(7,0,0);
        cube1(3,3,0.2,1,1,23);
    glPopMatrix;

glPopMatrix;
//**
}

{
//** sakhtemane edari
glPushMatrix;

    glPushMatrix;
        glTranslatef(0,0,0);
        cube1(35,9,15,2,5,20);
        glTranslatef(10,9,-5);
        cube1(15,4.5,10,1,2,20);
    glPopMatrix;

glPopMatrix;

//**
}
{
//** sarbazkhune
glPushMatrix;
glTranslatef(20,0,0);
    //front
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(8,9,0.2,2,2,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(8,6,0);
        cube(4,3,0.2,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(12,0,0);
        cube(8,9,0.2,2,2,13);
    glPopMatrix;
    //posht
    glPushMatrix;
        glTranslatef(0,0,-35);
        cube(20,9,0.2,2,2,13);
    glPopMatrix;
    //right
   glPushMatrix;
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,6,0);
        cube(0.2,3,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.2,4,5,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-9);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-19);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-29);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;
   glPopMatrix;
   //left
   glPushMatrix;
   glTranslatef(20,0,0);
    glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,6,0);
        cube(0.2,3,35,1,4,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.2,4,5,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-9);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-19);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;

    glPushMatrix;
        glTranslatef(0,2,-29);
        cube(0.2,4,6,1,1,13);
    glPopMatrix;
   glPopMatrix;
     //zamin
    glPushMatrix;
        glTranslatef(0.1,0,-0.1);
        cube(19.8,0.2,34.8,6,6,15);
    glPopMatrix;
    //saghf
    glPushMatrix;
        glTranslatef(0,9,0);
        cube(20,0.2,35,1,1,13);
    glPopMatrix;
    /////////////////
    //dar
    glPushMatrix;
        glTranslatef(8,0,0);
        glRotatef(80,0,1,0);
        cube(4,6,0.2,1,1,18);
    glPopMatrix;
    /////////////////
    //panjere right
    glPushMatrix;
      glPushMatrix;
        glTranslatef(0,2,-5);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-15);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-25);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;
    glPopMatrix;
    //panjere left
    glPushMatrix;
    glTranslatef(20,0,0);
      glPushMatrix;
        glTranslatef(0,2,-5);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-15);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;

      glPushMatrix;
        glTranslatef(0,2,-25);
        glColor4f(1,1,1,0.5);
        cube2(0.2,4,4,1,1,14);
      glPopMatrix;
    glPopMatrix;

glPopMatrix;
//**
}

{
//** tank

glPushMatrix;
    glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[1]);
        glBegin(GL_QUADS);
            //right
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,-13);

            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,1);  glVertex3f(22,6,0);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);
         glEnd;
         glBindTexture(GL_TEXTURE_2D,texture[0]);
         glBegin(GL_QUADS);
            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,1);  glVertex3f(2,6,0);
            glTexCoord2f(0,1);  glVertex3f(2,0,0);



            glColor3f(1,1,1);
            glTexCoord2f(0,0);  glVertex3f(22,0,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,1);  glVertex3f(24,4,0);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //left
            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,0,-13);



            glColor3f(0.8,0.8,0.8);
            glTexCoord2f(0,0);  glVertex3f(22,0,-13);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,-13);
        glEnd;
        glBindTexture(GL_TEXTURE_2D,texture[0]);
        glBegin(GL_QUADS);
            //jolo
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(0,2,0);
            glTexCoord2f(1,0);  glVertex3f(0,2,-13);
            glTexCoord2f(1,1);  glVertex3f(0,4,-13);
            glTexCoord2f(0,1);  glVertex3f(0,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(0,4,0);
            glTexCoord2f(1,0);  glVertex3f(0,4,-13);
            glTexCoord2f(1,1);  glVertex3f(2,6,-13);
            glTexCoord2f(0,1);  glVertex3f(2,6,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,0,0);
            glTexCoord2f(1,0);  glVertex3f(2,0,-13);
            glTexCoord2f(1,1);  glVertex3f(0,2,-13);
            glTexCoord2f(0,1);  glVertex3f(0,2,0);
            //aghab
            glColor3f(0.9,0.9,0.9);
            glTexCoord2f(0,0);  glVertex3f(22,6,0);
            glTexCoord2f(1,0);  glVertex3f(22,6,-13);
            glTexCoord2f(1,1);  glVertex3f(24,4,-13);
            glTexCoord2f(0,1);  glVertex3f(24,4,0);

            glColor3f(0.7,0.7,0.7);
            glTexCoord2f(0,0);  glVertex3f(24,2,0);
            glTexCoord2f(1,0);  glVertex3f(24,2,-13);
            glTexCoord2f(1,1);  glVertex3f(22,0,-13);
            glTexCoord2f(0,1);  glVertex3f(22,0,0);

            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(24,4,0);
            glTexCoord2f(1,0);  glVertex3f(24,4,-13);
            glTexCoord2f(1,1);  glVertex3f(24,2,-13);
            glTexCoord2f(0,1);  glVertex3f(24,2,0);
            //balla
            glColor3f(0.6,0.6,0.6);
            glTexCoord2f(0,0);  glVertex3f(2,6,0);
            glTexCoord2f(1,0);  glVertex3f(2,6,-13);
            glTexCoord2f(1,1);  glVertex3f(22,6,-13);
            glTexCoord2f(0,1);  glVertex3f(22,6,0);
        glEnd;
    glPopMatrix;
    //loleye top
    glPushMatrix;
        glPushMatrix;
            glTranslatef(8,6,-4);
            cube(5,3,5,1,1,0);
            glTranslatef(-1,0,1);
            cube(7,1,7,1,1,0);
        glPopMatrix;
        glPushMatrix;
            glBindTexture(GL_TEXTURE_2D,texture[0]);
            glTranslatef(-7.8,9.8,-6.5);
            glRotatef(90,0,1,-0.1);
            gluCylinder(quadratic,0.5,0.5,16,12,1);
        glPopMatrix;
    glPopMatrix;

glPopMatrix;

//**
}

{
//** heli coopter
glPushMatrix;

   glBindTexture(GL_TEXTURE_2D,texture[3]);
   glBegin(GL_QUADS);
      ////-------------right-----------////
      glColor3f(1,1,1);
      glTexCoord2f(0,0);  glVertex3f(0,2,0);
      glTexCoord2f(1,0);  glVertex3f(0,4,0);
      glTexCoord2f(1,1);  glVertex3f(2,4,2);
      glTexCoord2f(0,1);  glVertex3f(2,2,2);

      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(2,4,2);
      glTexCoord2f(1,0);  glVertex3f(2,6,0);
      glTexCoord2f(1,1);  glVertex3f(7,6,0);
      glTexCoord2f(0,1);  glVertex3f(7,4,2);

      glColor3f(0.9,0.9,0.9);
      glTexCoord2f(0,0);  glVertex3f(2,2,2);
      glTexCoord2f(1,0);  glVertex3f(2,4,2);
      glTexCoord2f(1,1);  glVertex3f(7,4,2);
      glTexCoord2f(0,1);  glVertex3f(7,2,2);

      glColor3f(0.5,0.5,0.5);
      glTexCoord2f(0,0);  glVertex3f(2,0,0);
      glTexCoord2f(1,0);  glVertex3f(2,2,2);
      glTexCoord2f(1,1);  glVertex3f(7,2,2);
      glTexCoord2f(0,1);  glVertex3f(7,0,0);

      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(7,4,2);
      glTexCoord2f(1,0);  glVertex3f(7,6,0);
      glTexCoord2f(1,1);  glVertex3f(10,6,0);
      glTexCoord2f(0,1);  glVertex3f(10,5,0);

      glColor3f(1,1,1);
      glTexCoord2f(0,0);  glVertex3f(7,2,2);
      glTexCoord2f(1,0);  glVertex3f(7,4,2);
      glTexCoord2f(1,1);  glVertex3f(10,5,0);
      glTexCoord2f(0,1);  glVertex3f(8.2,2,0);
      ////-------------left-----------////
      glColor3f(1,1,1);
      glTexCoord2f(0,0);  glVertex3f(0,2,-1);
      glTexCoord2f(1,0);  glVertex3f(0,4,-1);
      glTexCoord2f(1,1);  glVertex3f(2,4,-3);
      glTexCoord2f(0,1);  glVertex3f(2,2,-3);

      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(2,4,-3);
      glTexCoord2f(1,0);  glVertex3f(2,6,-1);
      glTexCoord2f(1,1);  glVertex3f(7,6,-1);
      glTexCoord2f(0,1);  glVertex3f(7,4,-3);

      glColor3f(0.9,0.9,0.9);
      glTexCoord2f(0,0);  glVertex3f(2,2,-3);
      glTexCoord2f(1,0);  glVertex3f(2,4,-3);
      glTexCoord2f(1,1);  glVertex3f(7,4,-3);
      glTexCoord2f(0,1);  glVertex3f(7,2,-3);

      glColor3f(0.5,0.5,0.5);
      glTexCoord2f(0,0);  glVertex3f(2,0,-1);
      glTexCoord2f(1,0);  glVertex3f(2,2,-3);
      glTexCoord2f(1,1);  glVertex3f(7,2,-3);
      glTexCoord2f(0,1);  glVertex3f(7,0,-1);

      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(7,4,-3);
      glTexCoord2f(1,0);  glVertex3f(7,6,-1);
      glTexCoord2f(1,1);  glVertex3f(10,6,-1);
      glTexCoord2f(0,1);  glVertex3f(10,5,-1);

      glColor3f(1,1,1);
      glTexCoord2f(0,0);  glVertex3f(7,2,-3);
      glTexCoord2f(1,0);  glVertex3f(7,4,-3);
      glTexCoord2f(1,1);  glVertex3f(10,5,-1);
      glTexCoord2f(0,1);  glVertex3f(8.2,2,-1);
      //-------------vasat-------------//
      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(2,0,0);
      glTexCoord2f(1,0);  glVertex3f(2,0,-1);
      glTexCoord2f(1,1);  glVertex3f(0,2,-1);
      glTexCoord2f(0,1);  glVertex3f(0,2,0);

      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(0,2,0);
      glTexCoord2f(1,0);  glVertex3f(0,2,-1);
      glTexCoord2f(1,1);  glVertex3f(0,4,-1);
      glTexCoord2f(0,1);  glVertex3f(0,4,0);



      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(2,6,0);
      glTexCoord2f(1,0);  glVertex3f(2,6,-1);
      glTexCoord2f(1,1);  glVertex3f(10,6,-1);
      glTexCoord2f(0,1);  glVertex3f(10,6,0);

      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(2,0,0);
      glTexCoord2f(1,0);  glVertex3f(2,0,-1);
      glTexCoord2f(1,1);  glVertex3f(7,0,-1);
      glTexCoord2f(0,1);  glVertex3f(7,0,0);

      glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(7,0,0);
      glTexCoord2f(1,0);  glVertex3f(7,0,-1);
      glTexCoord2f(1,1);  glVertex3f(10,5,-1);
      glTexCoord2f(0,1);  glVertex3f(10,5,0);
   glEnd;

   glBindTexture(GL_TEXTURE_2D,texture[5]);
   glBegin(GL_QUADS);
   glColor3f(0.7,0.7,0.7);
      glTexCoord2f(0,0);  glVertex3f(0,4,0);
      glTexCoord2f(1,0);  glVertex3f(0,4,-1);
      glTexCoord2f(1,1);  glVertex3f(2,6,-1);
      glTexCoord2f(0,1);  glVertex3f(2,6,0);
   glEnd;
   //noghate mosalasi kar
   glBindTexture(GL_TEXTURE_2D,texture[5]);
   glBegin(GL_TRIANGLES);
      //------------right-----------//
      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(0,4,-1);
      glTexCoord2f(1,0);  glVertex3f(2,6,-1);
      glTexCoord2f(1,1);  glVertex3f(2,4,-3);

      glColor3f(0.8,0.8,0.8);
      glTexCoord2f(0,0);  glVertex3f(0,4,0);
      glTexCoord2f(1,0);  glVertex3f(2,6,0);
      glTexCoord2f(1,1);  glVertex3f(2,4,2);
   glEnd;
   glBindTexture(GL_TEXTURE_2D,texture[3]);
   glBegin(GL_TRIANGLES);
      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(0,2,0);
      glTexCoord2f(1,0);  glVertex3f(2,2,2);
      glTexCoord2f(1,1);  glVertex3f(2,0,0);

      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(7,0,0);
      glTexCoord2f(1,0);  glVertex3f(8.2,2,0);
      glTexCoord2f(1,1);  glVertex3f(7,2,2);

      //------------left-----------//
      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(0,2,-1);
      glTexCoord2f(1,0);  glVertex3f(2,2,-3);
      glTexCoord2f(1,1);  glVertex3f(2,0,-1);

      glColor3f(0.6,0.6,0.6);
      glTexCoord2f(0,0);  glVertex3f(7,0,-1);
      glTexCoord2f(1,0);  glVertex3f(8.2,2,-1);
      glTexCoord2f(1,1);  glVertex3f(7,2,-3);

   glEnd;
   // dom
   glPushMatrix;
      glTranslatef(10,5,0);
      cube(9,1,1,1,1,3);
      glTranslatef(8.5,-1,0);
      cube(0.3,3,0.2,1,1,6);
   glPopMatrix;
   //charkhe helikopter
   glPushMatrix;
   glPushMatrix;
   glTranslatef(1,0,1);
      glPushMatrix;
      cube(7,0.3,0.3,1,1,6);
      glTranslatef(1,0,0);
      cube(0.2,1,0.3,1,1,6);
      glTranslatef(4,0,0);
      cube(0.2,1,0.3,1,1,6);
      glPopMatrix;
   glPopMatrix;

   glPushMatrix;
   glTranslatef(1,0,-1.7);
      glPushMatrix;
      cube(7,0.3,0.3,1,1,6);
      glTranslatef(1,0,0);
      cube(0.2,1,0.3,1,1,6);
      glTranslatef(4,0,0);
      cube(0.2,1,0.3,1,1,6);
      glPopMatrix;
   glPopMatrix;
   glPopMatrix;

   // malakhe havapeyma
   glPushMatrix;
      glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[6]);
        glTranslatef(4,6.9,-0.5);
        glRotatef(90,1,0,0);
        gluCylinder(quadratic,0.3,0.3,0.9,9,1);
      glPopMatrix;

      glPushMatrix;
        glPushMatrix;
          glTranslatef(4,6.5,-0.5);
          glRotatef(v_heli1,0,1,0);
          cube(13,0.2,0.6,1,1,6);
        glPopMatrix;

        glPushMatrix;
          glTranslatef(4,6.5,-0.5);
          glRotatef(v_heli1,0,1,0);
          cube(-13,0.2,0.6,1,1,6);
        glPopMatrix;
      glPopMatrix;

   glPopMatrix;

glPopMatrix;
//**
}

{
//** tofang arpiji

glPushMatrix;

    glPushMatrix;
    glTranslatef(2.99,1,0);
    cube(0.05,0.8,0.8,1,1,7);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(-0.04,1,0);
    cube(0.05,0.8,0.8,1,1,7);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(3,0.8,0.8,1,1,4);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.68,0.65,-0.35);
    cube(0.18,0.4,0.09,1,1,4);
    glPopMatrix;

glPopMatrix;

//**
}


{
//** tofang yozi

glPushMatrix;

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(1,0.23,0.12,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.25,0.52,0);
    cube(0.2,0.49,0.12,1,1,9);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(1,1.13,0);
    cube(1,0.1,0.12,1,1,4);
    glPopMatrix;

glPopMatrix;

//**
}

{
//** tofang kolt

glPushMatrix;

    glPushMatrix;
    glTranslatef(0,1,0);
    cube(1,0.18,0.09,1,1,8);
    glPopMatrix;

    glPushMatrix;
    glTranslatef(0.08,0.65,0);
    glRotatef(-12,0,0,1);
    cube(0.18,0.4,0.09,1,1,9);
    glPopMatrix;

glPopMatrix;

//**
}
{
//** parcham

glPushMatrix;
    glPushMatrix;
    glTranslatef(0,7,0);
    glRotatef(90,0,1,0);
        glBindTexture(GL_TEXTURE_2D,texture[30]);
        glBegin(GL_QUADS);

            glTexCoord2f(0,0);  glVertex3f(0,0,0);
            glTexCoord2f(1,0);  glVertex3f(0,3,0);
            glTexCoord2f(1,1);  glVertex3f(2,3,v_parcham1);
            glTexCoord2f(0,1);  glVertex3f(2,0,v_parcham1);

            glTexCoord2f(0,0);  glVertex3f(2,0,v_parcham1);
            glTexCoord2f(1,0);  glVertex3f(2,3,v_parcham1);
            glTexCoord2f(1,1);  glVertex3f(4,3,v_parcham2);
            glTexCoord2f(0,1);  glVertex3f(4,0,v_parcham2);

            glTexCoord2f(0,0);  glVertex3f(4,0,v_parcham2);
            glTexCoord2f(1,0);  glVertex3f(4,3,v_parcham2);
            glTexCoord2f(1,1);  glVertex3f(6,3,v_parcham1);
            glTexCoord2f(0,1);  glVertex3f(6,0,v_parcham1);

        glEnd;
        glPopMatrix;

        glPushMatrix;
        glBindTexture(GL_TEXTURE_2D,texture[4]);
        glTranslatef(0,10,0);
        glRotatef(90,1,0,0);
        gluCylinder(quadratic,0.2,0.2,10,15,1);
        glPopMatrix;

glPopMatrix;

//**
}

{
//** sandali

    glPushMatrix;
    glTranslatef(-1,0,-0.75);

        glPushMatrix;
        glTranslatef(0,1.2,0);
        cube(1.5,0.16,1.5,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.1,2.7,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.4,0,0);
        cube(0.1,1.2,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-1.4);
        cube(0.1,2.7,0.1,1,1,10);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.4,0,-1.4);
        cube(0.1,1.2,0.1,1,1,10);
        glPopMatrix;

        /////
        glPushMatrix;
        glTranslatef(0,2,0);
        cube(0.1,0.5,1.5,1,1,10);
        glPopMatrix;

    glPopMatrix;

//**

//** miz

    glPushMatrix;

        glPushMatrix;
        glTranslatef(0,2,0);
        cube(2,0.2,3,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,0);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(1.8,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0,0,-2.8);
        cube(0.2,2,0.2,1,1,11);
        glPopMatrix;

    glPopMatrix;
//**
}

{
//** takhtsarbazi

   glPushMatrix;
        // takhte khab
         glPushMatrix;
         glTranslatef(0,1,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,4,0);
         cube(3,0.4,-7,1,1,12);
         glPopMatrix;
        // end
        //paye takht
         glPushMatrix;
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,0);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(3,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;

         glPushMatrix;
         glTranslatef(0,0,7);
         cube(0.2,5,0.2,1,1,12);
         glPopMatrix;
         //end
         //pato
         glPushMatrix;
         glTranslatef(0.25,1.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,1.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
         //pato
         glPushMatrix;
         glTranslatef(0.25,4.4,0.5);
         cube(2.5,0.1,-5,1,1,0);
         glPopMatrix;
         //motaka
         glPushMatrix;
         glTranslatef(0.7,4.4,6);
         cube(1.5,0.2,-0.5,1,1,0);
         glPopMatrix;
   glPopMatrix;

//**
}

{
//** enfejar
     ////-----------dakheli
     glpushmatrix;
     glRotatef(rot_cube*80,0,1,0);
     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[16]);
        glColor4f(1,1,1,1-rot_triangle*1.5);
        glScalef(rot_cube*3,rot_cube*3,rot_cube*3);
        glBegin(GL_QUADS);
         glTexCoord2f(0,0);  glVertex3f(-1,0,0);
            glTexCoord2f(1,0);  glVertex3f(-1,1.0,0);
            glTexCoord2f(1,1);  glVertex3f(1,1.0,0);
            glTexCoord2f(0,1);  glVertex3f(1,0,0);
        glEnd;
     glPopMatrix;

     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[16]);
        glColor4f(1,1,1,1-rot_triangle*1.5);
        glRotatef(90,0,1,0);
        glScalef(rot_cube*2,rot_cube*2,rot_cube*2);
        glBegin(GL_QUADS);
         glTexCoord2f(0,0);  glVertex3f(-1,0,0);
            glTexCoord2f(1,0);  glVertex3f(-1,1.0,0);
            glTexCoord2f(1,1);  glVertex3f(1,1.0,0);
            glTexCoord2f(0,1);  glVertex3f(1,0,0);
        glEnd;
     glPopMatrix;

     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[16]);
        glColor4f(1,1,1,1-rot_triangle*1.5);
        glRotatef(135,0,1,0);
        glScalef(rot_cube*3.5,rot_cube*3.5,rot_cube*3.5);
        glBegin(GL_QUADS);
         glTexCoord2f(0,0);  glVertex3f(-1,0,0);
            glTexCoord2f(1,0);  glVertex3f(-1,1.0,0);
            glTexCoord2f(1,1);  glVertex3f(1,1.0,0);
            glTexCoord2f(0,1);  glVertex3f(1,0,0);
        glEnd;
     glPopMatrix;

     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[16]);
        glColor4f(1,1,1,1-rot_triangle*1.5);
        glRotatef(235,0,1,0);
        glScalef(rot_cube*2,rot_cube*2,rot_cube*2);
        glBegin(GL_QUADS);
         glTexCoord2f(0,0);  glVertex3f(-1,0,0);
            glTexCoord2f(1,0);  glVertex3f(-1,1.0,0);
            glTexCoord2f(1,1);  glVertex3f(1,1.0,0);
            glTexCoord2f(0,1);  glVertex3f(1,0,0);
        glEnd;
     glPopMatrix;
     glPopMatrix;
     //payane enfejar dakheli-------

     ////--------- bironi
     glpushmatrix;
        glBindTexture(GL_TEXTURE_2D,texture[17]);
        glColor4f(1,1,1,1-(rot_triangle*1.5));
        glRotatef(rot_cube*20,1,1,1);
        glScalef(rot_cube,rot_cube,rot_cube);
        gluSphere(quadratic,5,25,25);
     glpopmatrix;
     //payane enfejar bironi --------
//**
}


SwapBuffers(hdc);


end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  // meghdar dehi avaliye
  v_parcham_flag2:=1;
  dorbin_az_bala:=0;
  balapayin:=0;
  i:=0;
  y:=0;
  y3:=20;
  x3:=0;
  z:=0.5; zy:=0.5;
  z1:=10;z2:=10;
  t:=180;
  x1:= round(z1*cos(DegToRad(180+t)));
  y1:= round(z1*sin(DegToRad(180+t)));

  hdc:=GetDC(Handle);
  SetDCPixelFormat(hdc,16,16);
  initGL;
end;



procedure TForm1.FormResize(Sender: TObject);
begin

    wglMakeCurrent(hdc,hrc);
    glViewport(0,0,Width,Height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    gluPerspective(45,(Width/Height),1,1000);
    fwidth:=Width;fheight:=Height;
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity;
    InvalidateRect(Handle,nil,false);

end;

procedure TForm1.FormPaint(Sender: TObject);
begin
    wglMakeCurrent(hdc,hrc);
    DrawGLScene;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

    //harakate pare helicopter
    v_heli1:=v_heli1+(3+sorate_charkhesh);

    //harakate parcham
    if (v_parcham1 <= 0.7) and (v_parcham_flag1 = 0) then
    begin
      v_parcham1 := v_parcham1 + 0.01;
      v_parcham2 := v_parcham2 - 0.01;
    end
    else
      v_parcham_flag1 := 1;


    if (v_parcham1 >= -0.7) and (v_parcham_flag1 = 1)  then
    begin
      v_parcham1 := v_parcham1 - 0.01;
      v_parcham2 := v_parcham2 + 0.01;
    end
    else
      v_parcham_flag1 := 0;



    //char kheshe enfejar
    rot_triangle:=rot_triangle+0.01;
    rot_cube:=rot_cube+0.015;
    InvalidateRect(Handle,nil,false);

end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin

If key=('h') then
begin

  rot_cube:=0;
  rot_triangle:=0;

end;


If key=('l') then
begin

  dorbin_az_bala:=0;


end;

If Key=('k') then
begin

  dorbin_az_bala:=150;

end;

if key='m' then
sorate_charkhesh:=sorate_charkhesh+1;
if key='n' then
sorate_charkhesh:=sorate_charkhesh-1;

    if ((key='-')and(LightAmbient[0]>=0)) then
    begin
    LightAmbient[0]:=LightAmbient[0]-0.01;
    LightAmbient[1]:=LightAmbient[1]-0.01;
    LightAmbient[2]:=LightAmbient[2]-0.01;
    glLightfv(GL_LIGHT0,GL_AMBIENT,@LightAmbient);
    InvalidateRect(handle,nil,false);
    end;

    // baraye bishtar kardane nore mohiti
    if ((key='+')and(LightAmbient[0]<=1)) then
    begin
    LightAmbient[0]:=LightAmbient[0]+0.01;
    LightAmbient[1]:=LightAmbient[1]+0.01;
    LightAmbient[2]:=LightAmbient[2]+0.01;
    glLightfv(GL_LIGHT0,GL_AMBIENT,@LightAmbient);
    InvalidateRect(handle,nil,false);
    end;

    //InvalidateRect(handle,nil,false);
    if Key=('s') then
begin
z2:=z2-1;
x3:=x3- ((round(z2*cos(DegToRad(180+t))))/50);
y3:=y3- ((round(z2*sin(DegToRad(180+t))))/50);
z2:=5;

end;
if Key=('w') then
begin
z2:=z2+20;
x3:=x3+ ((round(z2*cos(DegToRad(180+t))))/50);
y3:=y3+ ((round(z2*sin(DegToRad(180+t))))/50);
z2:=5;
end;

if Key=('d') then
begin
z1:=5;
t:=t+4;
x1:= round(z1*cos(DegToRad(180+t)));
y1:= round(z1*sin(DegToRad(180+t)));
  if (t>=180) then t:=-180;
end;

if Key=('a') then
begin
z1:=5;
t:=t-4;
x1:= round((z1)*cos(DegToRad(180+t)));
y1:= round((z1)*sin(DegToRad(180+t)));
  if (t<=-180) then t:=180;
end;

if (key=('q'))and(balapayin<30) then
begin
    balapayin:=balapayin+0.3;
end;

if (key=('e'))and(balapayin>-30) then
begin
    balapayin:=balapayin-0.3;
end;

end;

end.
