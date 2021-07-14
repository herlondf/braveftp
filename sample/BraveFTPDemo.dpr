program BraveFTPDemo;

uses
  Vcl.Forms,
  Demo.View in 'Demo.View.pas' {Form1},
  BraveFTP.Interfaces in '..\src\BraveFTP.Interfaces.pas',
  BraveFTP in '..\src\BraveFTP.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
