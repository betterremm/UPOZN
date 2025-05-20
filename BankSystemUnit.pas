Unit BankSystemUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.ComCtrls,
    Vcl.StdCtrls,
    Vcl.Menus,
    Vcl.Buttons,
    Vcl.Grids;

Type
    TBankForm = Class(TForm)
        StringGrid1: TStringGrid;
    MainMenu: TMainMenu;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
        NFile: TMenuItem;
        NOpen: TMenuItem;
        NSave: TMenuItem;
        NBlank: TMenuItem;
        NClose: TMenuItem;
        NInstr: TMenuItem;
        NDev: TMenuItem;
    CBChoice: TComboBox;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure NCloseClick(Sender: TObject);
    procedure NSaveClick(Sender: TObject);
    procedure NOpenClick(Sender: TObject);
    procedure NDevClick(Sender: TObject);
    procedure NInstrClick(Sender: TObject);
    procedure SBtnAccountsClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    BankForm: TBankForm;

Implementation

{$R *.dfm}

Procedure TBankForm.FormCreate(Sender: TObject);
Begin
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
End;

Function TBankForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

Procedure TBankForm.NCloseClick(Sender: TObject);
Begin
    Close

End;

procedure TBankForm.NDevClick(Sender: TObject);
begin
    //DevForm.Open
end;

procedure TBankForm.NInstrClick(Sender: TObject);
begin
    //InstrForm.Open
end;

procedure TBankForm.NOpenClick(Sender: TObject);
begin
    //TODO: OpenFile
end;

procedure TBankForm.NSaveClick(Sender: TObject);
begin
    //TODO: SaveFile
end;

procedure TBankForm.SBtnAccountsClick(Sender: TObject);
begin
    SBtnAccounts.Down := True;
end;

End.
