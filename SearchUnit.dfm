object SearchForm: TSearchForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1086#1080#1089#1082
  ClientHeight = 170
  ClientWidth = 218
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
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 212
    Height = 15
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1088#1077#1076#1080' '#1095#1077#1075#1086' '#1074#1099' '#1093#1086#1090#1080#1090#1077' '#1080#1089#1082#1072#1090#1100
  end
  object Label2: TLabel
    Left = 44
    Top = 58
    Width = 129
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1076' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
  end
  object CBChoice: TComboBox
    Left = 34
    Top = 30
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 0
    Items.Strings = (
      #1050#1083#1080#1077#1085#1090#1099
      #1057#1095#1077#1090#1072)
  end
  object EditCode: TEdit
    Left = 46
    Top = 80
    Width = 121
    Height = 23
    MaxLength = 8
    TabOrder = 1
    OnChange = EditCodeChange
    OnKeyPress = EditCodeKeyPress
  end
  object BtnAccept: TButton
    Left = 71
    Top = 125
    Width = 75
    Height = 25
    Caption = #1055#1086#1080#1089#1082
    TabOrder = 2
    OnClick = BtnAcceptClick
  end
end
