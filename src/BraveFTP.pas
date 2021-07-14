unit BraveFTP;

interface

uses
  {Embarcadero}
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  System.Classes,
  System.SysUtils,
  System.Variants,
  Winapi.Windows,
  System.Generics.Collections,

  {Indy}
  IdText,
  IdContext,
  IdFTPServer,
  IdAttachmentFile,
  IdBaseComponent,
  IdTCPConnection,
  IdExplicitTLSClientServerBase,
  IdComponent,
  IdTCPClient,
  IdIOHandler,
  IdCustomTCPServer,
  IdFTP,
  IdIOHandlerSocket,
  IdTCPServer,
  IdGlobal,
  IdIOHandlerStack,
  IdCmdTCPServer,
  IdFTPCommon,
  IdSSL,
  IdAntiFreezeBase,
  IdSMTP,
  IdIntercept,
  IdAntiFreeze,
  IdSSLOpenSSL,
  IdFTPList,
  IdMessage,
  IdAllFTPListParsers,

  {Brave}
  BraveFTP.Interfaces;

type
  TBraveFTP = class(TInterfacedObject, iBraveFTP)
    constructor Create;
    destructor Destroy; override;
    class function New: iBraveFTP;
  strict private
    FThread        : TThread;
  private
    FIdFTP : TIdFTP;
    FProxy : TIdFtpProxySettings;
    FIdSSL : TIdSSLIOHandlerSocketOpenSSL;

    { Integration }
    FBraveFTPLog        : TBraveFTPLog;
    FProgressBar        : TProgressBar;
    FProgressBarLabel   : TLabel;

    function Connect    : iBraveFTP;

    procedure OnConnected( Sender: TObject                                              );
    procedure OnWork     ( ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64    );
    procedure OnWorkBegin( ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64 );
    procedure OnWorkEnd  ( ASender: TObject; AWorkMode: TWorkMode                       );
    procedure OnStatus   ( ASender: TObject; const AStatus: TIdStatus; const AStatusText: string );

    procedure Log( const Value: String );
    { Private declarations }
  public
    { Integration }
    function OnLog          ( const Value: TBraveFTPLog ): iBraveFTP;
    function OnProgress     ( const Value: TComponent   ): iBraveFTP;
    function OnProgressLabel( const Value: TComponent   ): iBraveFTP;

    { Attributes of connection }
    function Hostname      ( const Value: String  ): iBraveFTP;
    function Username      ( const Value: String  ): iBraveFTP;
    function Password      ( const Value: String  ): iBraveFTP;
    function Port          ( const Value: Integer ): iBraveFTP; overload;
    function Port          ( const Value: String  ): iBraveFTP; overload;
    function ProxyHostname ( const Value: String  ): iBraveFTP;
    function ProxyUsername ( const Value: String  ): iBraveFTP;
    function ProxyPassword ( const Value: String  ): iBraveFTP;
    function ProxyPort     ( const Value: Integer ): iBraveFTP; overload;
    function ProxyPort     ( const Value: String  ): iBraveFTP; overload;
    function Passive       ( const Value: Boolean ): iBraveFTP;
    function UseTLS        ( const Value: Boolean ): iBraveFTP;

    { Tranfers files }
    function Get( const ASource, aDest: String ): iBraveFTP;
    function Put( const ASource, aDest: String ): iBraveFTP;

    { Manipulating of directory and files }
    function RootDir   : iBraveFTP;
    function CurrentDir: iBraveFTP;
    function ListDir   : iBraveFTP;

    function CreateDir( const ADirectory: String ): iBraveFTP;
    function ChangeDir( const ADirectory: String ): iBraveFTP;

    function ExistsFile( AFilename: String = '' ): Boolean;

    { Thread Tratament }
    function Start: iBraveFTP;
    { Public declarations }
  end;

implementation

{ TBraveFTP }

constructor TBraveFTP.Create;
begin
  FIdFTP := TIdFTP.Create(nil);

  FIdFTP.UseMLIS               := True;
  FIdFTP.UseHOST               := True;
  FIdFTP.ListenTimeout         := 10000;
  FIdFTP.ReadTimeout           := 30000;
  FIdFTP.TransferTimeout       := 10000;
  FIdFTP.TransferType          := ftBinary;
  FIdFTP.Passive               := True;
  FIdFTP.PassiveUseControlHost := True;
  FIdFTP.Port                  := 21;

  FIdFTP.OnConnected           := OnConnected;
  FIdFTP.OnStatus              := OnStatus;
  FIdFTP.OnWork                := OnWork;
  FIdFTP.OnWorkBegin           := OnWorkBegin;
  FIdFTP.OnWorkEnd             := OnWorkEnd;

  FProxy                       := TIdFtpProxySettings.Create;

  FIdSSL                       := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
end;

destructor TBraveFTP.Destroy;
begin
  FreeAndNil( FIdFTP   );
  FreeAndNil( FProxy   );
  FreeAndNil( FIdSSL   );

  inherited;
end;

class function TBraveFTP.New: iBraveFTP;
begin
  Result := Self.Create;
end;

procedure TBraveFTP.OnConnected( Sender: TObject );
begin
  //
end;

procedure TBraveFTP.OnStatus( ASender: TObject; const AStatus: TIdStatus; const AStatusText: string );
begin
  case AStatus of
    hsResolving     : Log(AStatusText);
    hsConnecting    : Log(AStatusText);
    hsConnected     : Log(AStatusText);
    hsDisconnecting : Log(AStatusText);
    hsDisconnected  : Log(AStatusText);
    hsStatusText    : Log(AStatusText);
    ftpTransfer     : Log(AStatusText);
    ftpReady        : Log(AStatusText);
    ftpAborted      : Log(AStatusText);
  end;
end;

procedure TBraveFTP.OnWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  TThread.CreateAnonymousThread(
  procedure
  begin
    TThread.Synchronize(TThread.Current,
    procedure
    var
      LSizeTransfered: Integer;
    begin
      LSizeTransfered := AWorkCount div 1024;

      if Assigned( FProgressBarLabel ) then
        FProgressBarLabel.Caption := 'Transferido: ' + IntToStr( LSizeTransfered ) + '/kb.';


      if Assigned( FProgressBar ) then
      begin
        if FProgressBar.Tag = 0 then
          FProgressBar.Position := AWorkCount
        else
          FProgressBar.Position := LSizeTransfered;
      end;
    end);
  end).Start;
end;

procedure TBraveFTP.OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if Assigned( FProgressBar ) then
  begin
    if AWorkCountMax > 0 then
    begin
      FProgressBar.Max := AWorkCountMax;
      FProgressBar.Tag := 0;
    end
    else
    begin
      FProgressBar.Max := 100;
      FProgressBar.Tag := 1;
    end;

    FProgressBar.Min      := 0;
    FProgressBar.Position := 0;
  end;

  if Assigned(FProgressBarLabel) then
    FProgressBarLabel.Visible := True;
end;

procedure TBraveFTP.OnWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if Assigned( FProgressBar ) then
    FProgressBar.Position := 0;

  if Assigned(FProgressBarLabel) then
    FProgressBarLabel.Visible := False;
end;

procedure TBraveFTP.Log( const Value: String );
begin
  if Assigned( FBraveFTPLog ) then
    FBraveFTPLog( Value );
end;

function TBraveFTP.Connect: iBraveFTP;
begin
  Result := Self;

  try
    if FidFTP.Connected then
      FIdFTP.Disconnect;

    FIdFTP.Connect();
  except
    on E: Exception do
    begin
      Log( 'Houston, we have problem...' );
      Log( E.Message );
      raise;
    end;
  end;
end;

function TBraveFTP.Hostname( const Value: String  ): iBraveFTP;
begin
  Result      := Self;
  FIdFTP.Host := Value;
end;

function TBraveFTP.Username( const Value: String  ): iBraveFTP;
begin
  Result          := Self;
  FIdFTP.Username := Value;
end;

function TBraveFTP.Password( const Value: String  ): iBraveFTP;
begin
  Result          := Self;
  FIdFTP.Password := Value;
end;

function TBraveFTP.Port( const Value: Integer ): iBraveFTP;
begin
  Result      := Self;
  FIdFTP.Port := Value;
end;

function TBraveFTP.Port( const Value: String ): iBraveFTP;
begin
  Result      := Self;
  FIdFTP.Port := StrToIntDef( Value, 21 );
end;

function TBraveFTP.ProxyHostname( const Value: String  ): iBraveFTP;
begin
  Result := Self;

  if not Assigned( FIdFTP.ProxySettings ) then
    FIdFTP.ProxySettings := FProxy;

  FProxy.Host := Value;
end;

function TBraveFTP.ProxyUsername( const Value: String  ): iBraveFTP;
begin
  Result := Self;

  if not Assigned( FIdFTP.ProxySettings ) then
    FIdFTP.ProxySettings := FProxy;

  FProxy.UserName := Value;
end;

function TBraveFTP.ProxyPassword( const Value: String  ): iBraveFTP;
begin
  Result := Self;

  if not Assigned( FIdFTP.ProxySettings ) then
    FIdFTP.ProxySettings := FProxy;

  FProxy.Password := Value;
end;

function TBraveFTP.ProxyPort( const Value: Integer ): iBraveFTP;
begin
  Result := Self;

  if not Assigned( FIdFTP.ProxySettings ) then
    FIdFTP.ProxySettings := FProxy;

  FProxy.Port := Value;
end;

function TBraveFTP.ProxyPort( const Value: String ): iBraveFTP;
begin
  Result := Self;

  if not Assigned( FIdFTP.ProxySettings ) then
    FIdFTP.ProxySettings := FProxy;

  FProxy.Port := StrToIntDef( Value, 21 );
end;

function TBraveFTP.Passive( const Value: Boolean ): iBraveFTP;
begin
  Result                       := Self;
  FIdFTP.Passive               := Value;
  FIdFTP.PassiveUseControlHost := Value;
end;

function TBraveFTP.UseTLS( const Value: Boolean ): iBraveFTP;
begin
  Result := Self;

  if Value then
  begin
    FIdFTP.IOHandler           := FIdSSL;
    FIdFTP.UseTLS              := utUseExplicitTLS;
    FIdFTP.AUTHCmd             := tAuthTLS;
    FIdFTP.DataPortProtection  := ftpdpsPrivate;
  end;
end;

function TBraveFTP.OnLog( const Value: TBraveFTPLog ): iBraveFTP;
begin
  Result       := Self;
  FBraveFTPLog := Value;
end;

function TBraveFTP.OnProgress( const Value: TComponent   ): iBraveFTP;
begin
  Result       := Self;
  FProgressBar := TProgressBar( Value );
end;

function TBraveFTP.OnProgressLabel( const Value: TComponent   ): iBraveFTP;
begin
  Result := Self;
  FProgressBarLabel := TLabel( Value );
end;

function TBraveFTP.Get(const ASource, aDest: String): iBraveFTP;
begin
  Result := Self;

  if FileExists( ADest ) then
    DeleteFile( PWideChar( ADest ) );

  while Assigned(FThread) do
    TThread.Sleep(50);

  FThread :=
    TThread.CreateAnonymousThread(
    procedure
    begin
      try
        try
          Connect;

          if FIdFTP.Connected then
            FIdFTP.Get(ASource, aDest, False);
        except
          on E: Exception do
          begin
            Log(E.Message);
            FIdFTP.KillDataChannel;
            FIdFTP.Disconnect;
          end;
        end;
      finally
        FIdFTP.KillDataChannel;
        FIdFTP.Disconnect;
      end;
    end);
end;

function TBraveFTP.Put(const ASource, aDest: String): iBraveFTP;
var
  LSourceStream: TStream;
  LDestFileName: String;
begin
  Result := Self;

//  while Assigned(FThread) do
//    TThread.Sleep(50);
//
//  FThread :=
//    TThread.CreateAnonymousThread(
//    procedure
//    begin
      LDestFileName := ADest;

      if LDestFileName = '' then begin
        LDestFileName := ExtractFileName( ASource );
      end;

      LSourceStream := TIdReadFileNonExclusiveStream.Create( ASource );

      try
        try
          Connect;

          if FIdFTP.Connected then
            FIdFTP.Put( LSourceStream, LDestFileName, True, 0 );
        finally
          FreeAndNil(LSourceStream);
          FIdFTP.KillDataChannel;
          FIdFTP.Disconnect;
        end;
      except
        on E: Exception do
        begin
          Log(E.Message);
          FreeAndNil(LSourceStream);
          FIdFTP.KillDataChannel;
          FIdFTP.Disconnect;
        end;
      end;
//    end);
end;

function TBraveFTP.RootDir: iBraveFTP;
begin
  Result := Self;

  if FIdFTP.Connected then
  begin
    while FIdFTP.RetrieveCurrentDir <> '/' do
    begin
      Sleep(5000);
      FIdFTP.ChangeDirUp;
    end;
  end;
end;

function TBraveFTP.CurrentDir: iBraveFTP;
begin
  Result := Self;

  if FIdFTP.Connected then
    FIdFTP.RetrieveCurrentDir;
end;

function TBraveFTP.ListDir: iBraveFTP;
var
  I: Integer;
  LDirectorys: TStringList;
begin
  LDirectorys := TStringList.Create;
  FIdFTP.List( LDirectorys, '', false );

  for I := 0 to Pred( LDirectorys.Count ) do
    Log( LDirectorys.Strings[I] );

  LDirectorys.Free;
end;

function TBraveFTP.CreateDir(const ADirectory: String): iBraveFTP;
var
  LDirectorys: TStringList;
begin
  if FIdFTP.Connected then
  begin
    try
      LDirectorys := TStringList.Create;

      FIdFTP.List( LDirectorys, '', false );

      if LDirectorys.IndexOf( aDirectory ) <> - 1 then
        FIdFTP.ChangeDir( aDirectory )
      else
      begin
        try
          FIdFTP.MakeDir( aDirectory );
        finally
          FIdFTP.ChangeDir( aDirectory );
          FreeAndNil( LDirectorys );
        end;
      end;
    except
      FreeAndNil( LDirectorys );
    end;
  end;
end;

function TBraveFTP.ChangeDir(const ADirectory: String): iBraveFTP;
begin
  try
    FIdFTP.ChangeDir( ADirectory );
  except
    try
      Log('Ops, this directory dont exists but lets create...');
      CreateDir( ADirectory );

      Sleep(1000);

      FIdFTP.ChangeDir( ADirectory );
      Log('Directory actual is ' + ADirectory);
    except
      On E: Exception do
      begin
        Log('Ops, we have a problem...' + E.Message);
        raise;
      end;
    end;

  end;
end;

function TBraveFTP.ExistsFile( AFilename: String = '' ): Boolean;
var
  I           : Integer;
  LDirectorys : TStringList;
begin
  LDirectorys := TStringList.Create;

  try
    FIdFTP.List( LDirectorys, '', False );
  except
    //
  end;

  for I := 0 to Pred( LDirectorys.Count ) do
  begin
    Result := AnsiUpperCase( AFilename ) = AnsiUpperCase( LDirectorys.Strings[I] );

    if Result then Break
  end;

  LDirectorys.Free;
end;

function TBraveFTP.Start: iBraveFTP;
begin
  Result := Self;

  FThread.FreeOnTerminate := True;
  FThread.Start;

  while not FThread.Finished do
    TThread.Sleep(50);

  FThread := nil;
end;

end.
