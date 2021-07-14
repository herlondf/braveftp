object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 402
  ClientWidth = 568
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblHost: TLabel
    Left = 8
    Top = 37
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object lblUsername: TLabel
    Left = 239
    Top = 37
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object lblPassword: TLabel
    Left = 366
    Top = 37
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object lblPort: TLabel
    Left = 493
    Top = 37
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object lblProxyHost: TLabel
    Left = 8
    Top = 93
    Width = 53
    Height = 13
    Caption = 'Proxy Host'
  end
  object lblProxyUsername: TLabel
    Left = 239
    Top = 93
    Width = 82
    Height = 13
    Caption = 'Proxy  Username'
  end
  object lblProxyPassword: TLabel
    Left = 366
    Top = 93
    Width = 77
    Height = 13
    Caption = 'Proxy Password'
  end
  object lblProxyPort: TLabel
    Left = 493
    Top = 93
    Width = 51
    Height = 13
    Caption = 'Proxy Port'
  end
  object lblTransferLabel: TLabel
    Left = 8
    Top = 354
    Width = 17
    Height = 13
    Caption = '0%'
  end
  object Memo1: TMemo
    Left = 8
    Top = 240
    Width = 552
    Height = 108
    TabOrder = 0
  end
  object edtHost: TEdit
    Left = 8
    Top = 56
    Width = 225
    Height = 21
    TabOrder = 1
    Text = '64.31.26.5'
  end
  object edtUsername: TEdit
    Left = 239
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'viggoftp'
  end
  object edtPassword: TEdit
    Left = 366
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'V1gg0@d3v'
  end
  object edtPort: TEdit
    Left = 493
    Top = 56
    Width = 67
    Height = 21
    TabOrder = 4
    Text = '21'
  end
  object chkPassive: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Passive'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object chkUseTLS: TCheckBox
    Left = 111
    Top = 8
    Width = 97
    Height = 17
    Caption = 'TLS'
    TabOrder = 6
  end
  object edtProxyHost: TEdit
    Left = 8
    Top = 112
    Width = 225
    Height = 21
    TabOrder = 7
  end
  object edtProxyUsername: TEdit
    Left = 239
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 8
  end
  object edtProxyPassword: TEdit
    Left = 366
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 9
  end
  object edtProxyPort: TEdit
    Left = 493
    Top = 112
    Width = 67
    Height = 21
    TabOrder = 10
  end
  object pbTransfer: TProgressBar
    Left = 8
    Top = 373
    Width = 552
    Height = 17
    Smooth = True
    TabOrder = 11
  end
  object btnConnect: TButton
    Left = 8
    Top = 155
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 12
    OnClick = btnConnectClick
  end
  object btnChangeDir: TButton
    Left = 170
    Top = 195
    Width = 75
    Height = 25
    Caption = 'ChangeDir'
    TabOrder = 13
    OnClick = btnChangeDirClick
  end
  object btnRootDir: TButton
    Left = 170
    Top = 155
    Width = 75
    Height = 25
    Caption = 'RootDir'
    TabOrder = 14
    OnClick = btnRootDirClick
  end
  object btnCreateDir: TButton
    Left = 251
    Top = 155
    Width = 75
    Height = 25
    Caption = 'CreateDir'
    TabOrder = 15
    OnClick = btnCreateDirClick
  end
  object btnCurrentDir: TButton
    Left = 332
    Top = 155
    Width = 75
    Height = 25
    Caption = 'CurrentDir'
    TabOrder = 16
    OnClick = btnCurrentDirClick
  end
  object btnListDir: TButton
    Left = 413
    Top = 155
    Width = 75
    Height = 25
    Caption = 'ListDir'
    TabOrder = 17
    OnClick = btnListDirClick
  end
  object btnGet: TButton
    Left = 8
    Top = 195
    Width = 75
    Height = 25
    Caption = 'Get'
    TabOrder = 18
    OnClick = btnGetClick
  end
  object btnPut: TButton
    Left = 89
    Top = 195
    Width = 75
    Height = 25
    Caption = 'Put'
    TabOrder = 19
  end
  object btnDisconnect: TButton
    Left = 89
    Top = 155
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 20
    OnClick = btnDisconnectClick
  end
  object IdFTP1: TIdFTP
    OnStatus = IdFTP1Status
    IPVersion = Id_IPv4
    ConnectTimeout = 0
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 408
    Top = 184
  end
end
