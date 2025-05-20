Unit DevUnit;

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
    TDevForm = Class(TForm)
        Label1: TLabel;
    CloseDevBtn: TButton;
        Procedure CloseDevBtnClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    DevForm: TDevForm;

Implementation

{$R *.dfm}

Procedure TDevForm.CloseDevBtnClick(Sender: TObject);
Begin
    Close
End;

Procedure TDevForm.FormCreate(Sender: TObject);
Begin
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
End;

Function TDevForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

End.
