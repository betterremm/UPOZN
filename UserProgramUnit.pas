Unit UserProgramUnit;

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
    Vcl.Menus,
    Vcl.StdCtrls;

Type

    TUser = Record
        UserCode: Integer;
        SecondName: String[30];

    End;

    TUsersArray = Array Of TUser;

    TUserProgramForm = Class(TForm)
        BtnReadFromFile: TButton;
        BtnWatchLists: TButton;
        BtnSort: TButton;
        BtnSearch: TButton;
        BtnAdd: TButton;
        BtnDelete: TButton;
        BtnEdit: TButton;
        BtnTransfer: TButton;
        BtnCloseNoSave: TButton;
        BtnCloseWithSave: TButton;
        OpenDialog1: TOpenDialog;
        SaveDialog1: TSaveDialog;
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure FormCreate(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    UserProgramForm: TUserProgramForm;

Implementation

{$R *.dfm}

Procedure TUserProgramForm.FormCreate(Sender: TObject);
Begin
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
End;

Function TUserProgramForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

End.
