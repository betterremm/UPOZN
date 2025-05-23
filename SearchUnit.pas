Unit SearchUnit;

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
    Vcl.StdCtrls;

Type
    TSearchForm = Class(TForm)
    CBChoice: TComboBox;
        EditCode: TEdit;
        BtnAccept: TButton;
        Label1: TLabel;
        Label2: TLabel;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure EditCodeChange(Sender: TObject);
        Procedure EditCodeKeyPress(Sender: TObject; Var Key: Char);
        Procedure BtnAcceptClick(Sender: TObject);
    Private Const
        TAllowedKeys: Set Of Char = ['0' .. '9', #8, #127];

    Public
        ClosedByButton: Boolean;
    End;

Var
    SearchForm: TSearchForm;

Implementation

{$R *.dfm}

Procedure TSearchForm.BtnAcceptClick(Sender: TObject);
Begin
    ClosedByButton := True;
    Close;
End;

Procedure TSearchForm.EditCodeChange(Sender: TObject);
Begin

    If Length(EditCode.Text) > 0 Then
        BtnAccept.Enabled := True
    Else
        BtnAccept.Enabled := False;

End;

Procedure TSearchForm.EditCodeKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Not(Key In TAllowedKeys) Then
        Key := #0;
End;

Procedure TSearchForm.FormCreate(Sender: TObject);
Begin
    ClosedByButton := False;
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
End;

Function TSearchForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

End.
