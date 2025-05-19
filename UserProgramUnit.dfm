object UserProgramForm: TUserProgramForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1086#1077#1041#1072#1085#1082
  ClientHeight = 474
  ClientWidth = 226
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
  object BtnReadFromFile: TButton
    Left = 0
    Top = 8
    Width = 225
    Height = 41
    Caption = #1055#1088#1086#1095#1080#1090#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072
    TabOrder = 0
  end
  object BtnWatchLists: TButton
    Left = 0
    Top = 55
    Width = 225
    Height = 41
    Caption = #1055#1088#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1089#1087#1080#1089#1082#1080
    TabOrder = 1
  end
  object BtnSort: TButton
    Left = 0
    Top = 102
    Width = 225
    Height = 41
    Caption = #1054#1090#1089#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077
    TabOrder = 2
  end
  object BtnSearch: TButton
    Left = 0
    Top = 149
    Width = 225
    Height = 41
    Caption = #1055#1086#1080#1089#1082' '#1076#1072#1085#1085#1099#1093
    TabOrder = 3
  end
  object BtnAdd: TButton
    Left = 0
    Top = 196
    Width = 225
    Height = 41
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1089#1087#1080#1089#1086#1082
    TabOrder = 4
  end
  object BtnDelete: TButton
    Left = 0
    Top = 243
    Width = 225
    Height = 41
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1089#1087#1080#1089#1082#1072
    TabOrder = 5
  end
  object BtnEdit: TButton
    Left = 0
    Top = 290
    Width = 225
    Height = 41
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077
    TabOrder = 6
  end
  object BtnTransfer: TButton
    Left = 0
    Top = 337
    Width = 225
    Height = 41
    Caption = #1055#1077#1088#1077#1074#1077#1089#1090#1080' '#1076#1077#1085#1100#1075#1080' '#1085#1072' '#1089#1095#1077#1090
    TabOrder = 7
  end
  object BtnCloseNoSave: TButton
    Left = 0
    Top = 384
    Width = 225
    Height = 41
    Caption = #1042#1099#1081#1090#1080' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
    TabOrder = 8
  end
  object BtnCloseWithSave: TButton
    Left = 0
    Top = 431
    Width = 225
    Height = 41
    Caption = #1042#1099#1081#1090#1080' '#1089#1086#1093#1088#1072#1085#1080#1074' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    TabOrder = 9
  end
  object OpenDialog1: TOpenDialog
    Left = 208
    Top = 224
  end
  object SaveDialog1: TSaveDialog
    Left = 208
    Top = 248
  end
end
