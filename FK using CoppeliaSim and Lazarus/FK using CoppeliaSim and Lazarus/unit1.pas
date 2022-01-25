unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ExtCtrls, WinSock, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    ScrollBar4: TScrollBar;
    ScrollBar5: TScrollBar;
    ScrollBar6: TScrollBar;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure ScrollBar4Change(Sender: TObject);
    procedure ScrollBar5Change(Sender: TObject);
    procedure ScrollBar6Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  max, min: integer;
  step, scrollmax, scrollposition: real;
  pos: real;
  max1, max2 , max3, max4, max5, max6: integer; // макс паспортное значение угла поворота робота в градусах
  min1, min2 , min3, min4, min5, min6: integer; // минимальное паспортное значение угла поворота робота в градусах
  j1, j2, j3, j4, j5, j6: real; //значение угла поворота в радианах
  st: string;
  //-------------------TCP-------------------
  S:TSocket;
  Addr:TSockAddr;
  Data:TWSAData;

  i: integer;
  b: byte;
  bfr: TBytes;

implementation

{$R *.lfm}

{ TForm1 }

function scrollbar(max, min: integer): real;
begin
step:=0.1;
scrollmax:=(((abs(max)+abs(min))/step));
scrollposition:=(scrollmax/2);
end;

function scrolltext(scrollmax, scrollposition: real): real;
begin
  if (scrollposition=scrollmax/2) then
  begin
   pos:=0;
  end;
  if (scrollposition>scrollmax/2) then
  begin
   pos:=((((scrollmax/2)-scrollposition)*(-max))/scrollmax)*2;
  end;
  if (scrollposition<scrollmax/2) then
  begin
   pos:=((((scrollmax/2)-scrollposition)*min)/scrollmax)*2;
  end;
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  max:=max1;
  min:=min1;
  scrollposition:=ScrollBar1.Position;
  scrollmax:=ScrollBar1.Max;
  scrolltext(scrollmax, scrollposition);
  Edit1.Text:=FloatToStr(pos);
  j1:=(pos*Pi)/180; //переводим в радианы
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  max:=max2;
  min:=min2;
  scrollposition:=ScrollBar2.Position;
  scrollmax:=ScrollBar2.Max;
  scrolltext(scrollmax, scrollposition);
  Edit2.Text:=FloatToStr(pos);
  j2:=(pos*Pi)/180;
end;

procedure TForm1.ScrollBar3Change(Sender: TObject);
begin
  max:=max3;
  min:=min3;
  scrollposition:=ScrollBar3.Position;
  scrollmax:=ScrollBar3.Max;
  scrolltext(scrollmax, scrollposition);
  Edit3.Text:=FloatToStr(pos);
  j3:=(pos*Pi)/180;
end;

procedure TForm1.ScrollBar4Change(Sender: TObject);
begin
  max:=max4;
  min:=min4;
  scrollposition:=ScrollBar4.Position;
  scrollmax:=ScrollBar4.Max;
  scrolltext(scrollmax, scrollposition);
  Edit4.Text:=FloatToStr(pos);
  j4:=(pos*Pi)/180;
end;

procedure TForm1.ScrollBar5Change(Sender: TObject);
begin
  max:=max5;
  min:=min5;
  scrollposition:=ScrollBar5.Position;
  scrollmax:=ScrollBar5.Max;
  scrolltext(scrollmax, scrollposition);
  Edit5.Text:=FloatToStr(pos);
  j5:=(pos*Pi)/180;
end;

procedure TForm1.ScrollBar6Change(Sender: TObject);
begin
  max:=max6;
  min:=min6;
  scrollposition:=ScrollBar6.Position;
  scrollmax:=ScrollBar6.Max;
  scrolltext(scrollmax, scrollposition);
  Edit6.Text:=FloatToStr(pos);
  j6:=(pos*Pi)/180;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  max:=180;
  min:=-180;
  scrollbar(max, min);
  max1:=max;
  min1:=min;
  ScrollBar1.Max:=Round(scrollmax);
  ScrollBar1.Position:=Round(scrollposition);
  //-----------------------------------------
  max:=110;
  min:=-90;
  scrollbar(max, min);
  max2:=max;
  min2:=min;
  ScrollBar2.Max:=Round(scrollmax);
  ScrollBar2.Position:=Round(scrollposition);
  //-----------------------------------------
  max:=230;
  min:=-50;
  scrollbar(max, min);
  max3:=max;
  min3:=min;
  ScrollBar3.Max:=Round(scrollmax);
  ScrollBar3.Position:=Round(scrollposition);
  //-----------------------------------------
  max:=200;
  min:=-200;
  scrollbar(max, min);
  max4:=max;
  min4:=min;
  ScrollBar4.Max:=Round(scrollmax);
  ScrollBar4.Position:=Round(scrollposition);
  //-----------------------------------------
  max:=115;
  min:=-115;
  scrollbar(max, min);
  max5:=max;
  min5:=min;
  ScrollBar5.Max:=Round(scrollmax);
  ScrollBar5.Position:=Round(scrollposition);
  //-----------------------------------------
  max:=400;
  min:=-400;
  scrollbar(max, min);
  max6:=max;
  min6:=min;
  ScrollBar6.Max:=Round(scrollmax);
  ScrollBar6.Position:=Round(scrollposition);
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
 WSAStartup($101, Data); //загружаем WinSock;
 Timer1.Enabled:=true;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
 Timer1.Enabled:=false;
 Shutdown (s, 1); //завершение соединения
 CloseSocket(S); //отключение от сервера
 WSACleanup(); //выгрузка сетевой библиотеки
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
 Timer1.Enabled:=false;
 Shutdown (s, 1); //завершение соединения
 CloseSocket(S); //отключение от сервера
 WSACleanup(); //выгрузка сетевой библиотеки
 Close; //закрываем форму
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure StartSocket ();
begin
 s:=Socket(AF_INET, SOCK_STREAM,IPPROTO_IP); //создаем сокет
 Addr.sin_family:=AF_Inet; //задаем семейство адресов
 Addr.sin_port:=HToNS(5050); //задаем номер порта
 Addr.sin_addr.S_addr:=Inet_Addr('127.0.0.1'); //задаем IP-адрес
 FillChar(Addr.Sin_Zero,SizeOf(Addr.Sin_Zero),0); //заполняем нулями поля
 Connect(S,Addr,SizeOf(TSockAddr)); //подключаемся к серверу
 st:='[FK#J1='+FloatToStr(j1)+',J2='+FloatToStr(j2)+',J3='+FloatToStr(j3)+',J4='+FloatToStr(j5)+',J5='+FloatToStr(j4)+',J6='+FloatToStr(j6)+']';
 bfr:= SysUtils.TEncoding.ASCII.GetBytes(st + chr(13) + chr(10)); // переводим строку в массив байтов
 for i:=0 to ((Length(bfr))-1) do //отправляем данные на сервер по одному байту
  begin
  b:=bfr[i];
  Send(S,b,1,0);
  end;
 Shutdown (s, 1); //завершение соединения
 CloseSocket(S); //отключение от сервера
 sleep(1);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 StartSocket ();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 WSAStartup($101, Data); //загружаем WinSock;
 Timer1.Enabled:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Timer1.Enabled:=false;
 Shutdown (s, 1); //завершение соединения
 CloseSocket(S); //отключение от сервера
 WSACleanup(); //выгрузка сетевой библиотеки
end;

end.

