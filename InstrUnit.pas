Unit InstrUnit;

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
    TInstrForm = Class(TForm)
        Label1: TLabel;
    CloseInstrBtn: TButton;
        Procedure FormCreate(Sender: TObject);
        Procedure CloseInstrBtnClick(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    InstrForm: TInstrForm;

Implementation

{$R *.dfm}

Procedure TInstrForm.CloseInstrBtnClick(Sender: TObject);
Begin
    Close;
End;

Procedure TInstrForm.FormCreate(Sender: TObject);
Begin
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
End;

Function TInstrForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

End.
