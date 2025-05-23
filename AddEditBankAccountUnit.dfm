object AddEditBankAccountForm: TAddEditBankAccountForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1050#1083#1080#1077#1085#1090
  ClientHeight = 324
  ClientWidth = 167
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
  object LbAccNumber: TLabel
    Left = 24
    Top = 67
    Width = 71
    Height = 15
    Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072
  end
  object LbBalance: TLabel
    Left = 24
    Top = 115
    Width = 39
    Height = 15
    Caption = #1041#1072#1083#1072#1085#1089
  end
  object LbCollectionPercentage: TLabel
    Left = 8
    Top = 219
    Width = 157
    Height = 15
    Caption = #1055#1088#1086#1094#1077#1085#1090' '#1073#1072#1085#1082#1086#1074#1089#1082#1086#1075#1086' '#1089#1073#1086#1088#1072
  end
  object LbAccountType: TLabel
    Left = 24
    Top = 169
    Width = 53
    Height = 15
    Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
  end
  object EditCode: TEdit
    Left = 25
    Top = 40
    Width = 121
    Height = 23
    MaxLength = 9
    TabOrder = 0
    OnChange = EditCodeChange
    OnKeyPress = EditNumKeyPress
  end
  object BtnAccept: TButton
    Left = 40
    Top = 277
    Width = 83
    Height = 25
    Caption = #1055#1088#1080#1085#1103#1090#1100
    Enabled = False
    TabOrder = 5
    OnClick = BtnAcceptClick
  end
  object EditAccNumber: TEdit
    Left = 24
    Top = 88
    Width = 121
    Height = 23
    MaxLength = 9
    TabOrder = 1
    OnChange = EditAccNumberChange
    OnKeyPress = EditNumKeyPress
  end
  object EditBalance: TEdit
    Left = 25
    Top = 136
    Width = 121
    Height = 23
    MaxLength = 12
    TabOrder = 2
    OnChange = EditBalanceChange
    OnKeyPress = EditDecimalKeyPress
  end
  object EditCollectionPercentage: TEdit
    Left = 25
    Top = 240
    Width = 121
    Height = 23
    MaxLength = 4
    TabOrder = 4
    OnChange = EditCollectionPercentageChange
    OnKeyPress = EditDecimalKeyPress
  end
  object CBType: TComboBox
    Left = 24
    Top = 190
    Width = 122
    Height = 23
    Style = csDropDownList
    TabOrder = 3
    OnChange = CBTypeChange
    Items.Strings = (
      #1057#1073#1077#1088#1077#1075#1072#1090#1077#1083#1100#1085#1099#1081
      #1056#1072#1089#1095#1077#1090#1085#1099#1081
      #1050#1072#1088#1090#1086#1095#1085#1099#1081
      #1050#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090#1089#1082#1080#1081)
  end
end
