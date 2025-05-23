object BankForm: TBankForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1086#1077#1041#1072#1085#1082
  ClientHeight = 441
  ClientWidth = 609
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnHelp = FormHelp
  TextHeight = 15
  object LbComboBox: TLabel
    Left = 8
    Top = 8
    Width = 143
    Height = 15
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077', '#1089' '#1095#1077#1084' '#1088#1072#1073#1086#1090#1072#1090#1100
  end
  object SGMain: TStringGrid
    Left = 1
    Top = 138
    Width = 608
    Height = 304
    ColCount = 4
    DefaultColWidth = 150
    DefaultRowHeight = 30
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goFixedRowDefAlign]
    ScrollBars = ssVertical
    TabOrder = 0
    Visible = False
    OnSelectCell = SGMainSelectCell
  end
  object CBChoice: TComboBox
    Left = 8
    Top = 29
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 1
    OnChange = CBChoiceChange
    Items.Strings = (
      #1050#1083#1080#1077#1085#1090#1099
      #1057#1095#1077#1090#1072)
  end
  object BitBtnAdd: TBitBtn
    Left = 24
    Top = 80
    Width = 75
    Height = 25
    Caption = 'BitBtnAdd'
    Enabled = False
    TabOrder = 2
    OnClick = BitBtnAddClick
  end
  object BitBtnDelete: TBitBtn
    Left = 120
    Top = 80
    Width = 75
    Height = 25
    Caption = 'BitBtnDelete'
    Enabled = False
    TabOrder = 3
    OnClick = BitBtnDeleteClick
  end
  object BitBtnEdit: TBitBtn
    Left = 216
    Top = 80
    Width = 75
    Height = 25
    Caption = 'BitBtnEdit'
    Enabled = False
    TabOrder = 4
    OnClick = BitBtnEditClick
  end
  object BitBtnSort: TBitBtn
    Left = 312
    Top = 79
    Width = 75
    Height = 25
    Caption = 'BitBtnSort'
    Enabled = False
    TabOrder = 5
    OnClick = BitBtnSortClick
  end
  object BitBtnShowAccounts: TBitBtn
    Left = 408
    Top = 79
    Width = 121
    Height = 25
    Caption = 'BitBtnShowAccounts'
    Enabled = False
    TabOrder = 6
    OnClick = BitBtnShowAccountsClick
  end
  object BitBtnTransferMoney: TBitBtn
    Left = 408
    Top = 48
    Width = 121
    Height = 25
    Caption = 'BitBtnTransferMoney'
    Enabled = False
    TabOrder = 7
    OnClick = BitBtnTransferMoneyClick
  end
  object MainMenu: TMainMenu
    Left = 600
    Top = 104
    object NFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object NOpen: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        ShortCut = 16463
        OnClick = NOpenClick
      end
      object NSave: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ShortCut = 16467
        OnClick = NSaveClick
      end
      object NBlank: TMenuItem
        Caption = '-'
      end
      object NClose: TMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ShortCut = 16465
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
