object TransferMoneyForm: TTransferMoneyForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1077#1088#1077#1074#1086#1076
  ClientHeight = 278
  ClientWidth = 219
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
  object LbSender: TLabel
    Left = 48
    Top = 19
    Width = 98
    Height = 15
    Caption = #1057#1095#1077#1090' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
  end
  object LbRecipient: TLabel
    Left = 48
    Top = 83
    Width = 95
    Height = 15
    Caption = #1057#1095#1077#1090' '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1103
  end
  object Label1: TLabel
    Left = 48
    Top = 147
    Width = 94
    Height = 15
    Caption = #1056#1072#1079#1084#1077#1088' '#1087#1077#1088#1077#1074#1086#1076#1072
  end
  object EditSender: TEdit
    Left = 48
    Top = 40
    Width = 121
    Height = 23
    TabOrder = 0
    OnChange = EditSenderChange
    OnKeyPress = EditRecipientKeyPress
  end
  object EditRecipient: TEdit
    Left = 48
    Top = 104
    Width = 121
    Height = 23
    TabOrder = 1
    OnChange = EditRecipientChange
    OnKeyPress = EditRecipientKeyPress
  end
  object EditAmount: TEdit
    Left = 48
    Top = 168
    Width = 121
    Height = 23
    TabOrder = 2
    OnChange = EditAmountChange
    OnKeyPress = EditAmountKeyPress
  end
  object BtnAccept: TButton
    Left = 71
    Top = 245
    Width = 75
    Height = 25
    Caption = #1055#1077#1088#1077#1074#1077#1089#1090#1080
    TabOrder = 3
    OnClick = BtnAcceptClick
  end
  object CBSenderPays: TCheckBox
    Left = 32
    Top = 197
    Width = 156
    Height = 42
    Caption = #1050#1086#1084#1080#1089#1089#1080#1102' '#1086#1087#1083#1072#1095#1080#1074#1072#1077#1090#13#10#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100
    TabOrder = 4
  end
end
