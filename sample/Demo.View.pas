unit Demo.View;

interface

uses
  {Embarcadero}
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  {Brave}
  BraveFTP,
  BraveFTP.Interfaces, Vcl.ComCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdFTP;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    edtHost: TEdit;
    lblHost: TLabel;
    edtUsername: TEdit;
    lblUsername: TLabel;
    edtPassword: TEdit;
    lblPassword: TLabel;
    edtPort: TEdit;
    lblPort: TLabel;
    chkPassive: TCheckBox;
    chkUseTLS: TCheckBox;
    edtProxyHost: TEdit;
    lblProxyHost: TLabel;
    edtProxyUsername: TEdit;
    lblProxyUsername: TLabel;
    edtProxyPassword: TEdit;
    lblProxyPassword: TLabel;
    edtProxyPort: TEdit;
    lblProxyPort: TLabel;
    pbTransfer: TProgressBar;
    lblTransferLabel: TLabel;
    btnConnect: TButton;
    btnChangeDir: TButton;
    btnRootDir: TButton;
    btnCreateDir: TButton;
    btnCurrentDir: TButton;
    btnListDir: TButton;
    btnGet: TButton;
    btnPut: TButton;
    btnDisconnect: TButton;
    IdFTP1: TIdFTP;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnChangeDirClick(Sender: TObject);
    procedure btnListDirClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure IdFTP1Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure btnRootDirClick(Sender: TObject);
    procedure btnCreateDirClick(Sender: TObject);
    procedure btnCurrentDirClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
  private
    FBraveFTP: iBraveFTP;
    { Private declarations }
  public
    procedure Log(const Value: String);
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnChangeDirClick(Sender: TObject);
var
  LDirectory: String;
begin
  InputQuery('Ask', 'Whats a directory?', LDirectory);

  FBraveFTP
    .ChangeDir( LDirectory );
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  FBraveFTP
    .Hostname     ( edtHost.Text          )
    .Username     ( edtUsername.Text      )
    .Password     ( edtPassword.Text      )
    .Port         ( edtPort.Text          )
    .ProxyHostname( edtProxyHost.Text     )
    .ProxyUsername( edtProxyUsername.Text )
    .ProxyPassword( edtProxyPassword.Text )
    .ProxyPort    ( edtProxyPort.Text     )
    .UseTLS       ( chkUseTLS.Checked     )
    .Connect;
end;

procedure TForm1.btnCreateDirClick(Sender: TObject);
var
  LDirectory: String;
begin
  InputQuery('Ask', 'Whats is name a directory?', LDirectory);

  FBraveFTP
    .CreateDir(LDirectory);
end;

procedure TForm1.btnCurrentDirClick(Sender: TObject);
begin
  FBraveFTP
    .CurrentDir;
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  FBraveFTP
    .Disconnect;
end;

procedure TForm1.btnGetClick(Sender: TObject);
var
  LSource: String;
  LTarget: String;
begin
  InputQuery('Ask', 'Whats is filename?', LSource);
  InputQuery('Ask', 'Whats is a download target?', LTarget);

  FBraveFTP
    .Get(LSource, LTarget);
end;

procedure TForm1.btnListDirClick(Sender: TObject);
begin
  FBraveFTP
    .ListDir;
end;

procedure TForm1.btnRootDirClick(Sender: TObject);
begin
  FBraveFTP
    .RootDir;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FBraveFTP := TBraveFTP.New;

  FBraveFTP
    .OnLog          ( Log              )
    .OnProgress     ( pbTransfer       )
    .OnProgressLabel( lblTransferLabel );
end;

procedure TForm1.IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  //
end;

procedure TForm1.Log(const Value: String);
begin
  Memo1.Lines.Add(Value);
end;

end.
