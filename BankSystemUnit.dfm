object BankForm: TBankForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1086#1077#1041#1072#1085#1082
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHelp = FormHelp
  TextHeight = 15
  object StringGrid1: TStringGrid
    Left = 136
    Top = 192
    Width = 457
    Height = 241
    TabOrder = 0
  end
  object CBChoice: TComboBox
    Left = 8
    Top = 8
    Width = 145
    Height = 23
    ItemIndex = 0
    TabOrder = 1
    Text = #1057#1095#1077#1090#1072
    Items.Strings = (
      #1057#1095#1077#1090#1072
      #1050#1083#1080#1077#1085#1090#1099)
  end
  object MainMenu: TMainMenu
    Left = 600
    Top = 104
    object NFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object NOpen: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = NOpenClick
      end
      object NSave: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        OnClick = NSaveClick
      end
      object NBlank: TMenuItem
        Caption = '-'
      end
      object NClose: TMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100
        OnClick = NCloseClick
      end
    end
    object NInstr: TMenuItem
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1103
      OnClick = NInstrClick
    end
    object NDev: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
      OnClick = NDevClick
    end
  end
  object SaveDialog: TSaveDialog
    Filter = #1058#1080#1087#1080#1079#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1092#1072#1081#1083'|*.dat'
    Left = 600
    Top = 160
  end
  object OpenDialog: TOpenDialog
    Filter = #1058#1080#1087#1080#1079#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1092#1072#1081#1083'|*.dat'
    Left = 600
    Top = 216
  end
end
