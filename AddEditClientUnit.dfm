object AddEditClientForm: TAddEditClientForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1050#1083#1080#1077#1085#1090
  ClientHeight = 197
  ClientWidth = 171
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHelp = FormHelp
  TextHeight = 15
  object LbCode: TLabel
    Left = 24
    Top = 19
    Width = 67
    Height = 15
    Caption = #1050#1086#1076' '#1082#1083#1080#1077#1085#1090#1072
  end
  object LbSurname: TLabel
    Left = 24
    Top = 83
    Width = 51
    Height = 15
    Caption = #1060#1072#1084#1080#1083#1080#1103
  end
  object EditCode: TEdit
    Left = 24
    Top = 40
    Width = 121
    Height = 23
    MaxLength = 8
    TabOrder = 0
    OnChange = EditCodeChange
    OnContextPopup = EditCodeContextPopup
    OnKeyPress = EditCodeKeyPress
  end
  object EditSurname: TEdit
    Left = 24
    Top = 104
    Width = 121
    Height = 23
    MaxLength = 15
    TabOrder = 1
    OnChange = EditSurnameChange
  end
  object BtnAccept: TButton
    Left = 40
    Top = 160
    Width = 83
    Height = 25
    Caption = #1055#1088#1080#1085#1103#1090#1100
    Enabled = False
    TabOrder = 2
    OnClick = BtnAcceptClick
  end
end
