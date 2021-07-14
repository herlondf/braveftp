unit BraveFTP.Interfaces;

interface

uses
  System.Classes;

type
  TBraveFTPLog = procedure( const Value: String ) of Object;

  iBraveFTP = interface
    ['{340AA55F-36B9-4A9E-99C6-4A28E19EDD50}']
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

    { Integration }
    function OnLog          ( const Value: TBraveFTPLog ): iBraveFTP;
    function OnProgress     ( const Value: TComponent   ): iBraveFTP;
    function OnProgressLabel( const Value: TComponent   ): iBraveFTP;

    { Thread Tratament }
    function Start: iBraveFTP;

  end;

implementation

end.
