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
        SGMain: TStringGrid;
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
        BitBtnAdd: TBitBtn;
        BitBtnDelete: TBitBtn;
        BitBtnEdit: TBitBtn;
        BitBtnSort: TBitBtn;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure NCloseClick(Sender: TObject);
        Procedure NSaveClick(Sender: TObject);
        Procedure NOpenClick(Sender: TObject);
        Procedure NDevClick(Sender: TObject);
        Procedure NInstrClick(Sender: TObject);
        Procedure CBChoiceChange(Sender: TObject);
        Procedure WorkWithClients();
        Procedure WorkWithBankAccounts();
        Procedure ShowClients();
        Procedure ShowBankAccounts();
        Procedure BitBtnAddClick(Sender: TObject);
        Procedure BitBtnDeleteClick(Sender: TObject);
        Procedure DeleteClient();
        Procedure DeleteAccount();
        Procedure DeleteAllClientAccounts(ClientCode: Integer);

    Private
    { Private declarations }

        Type

        //Сберегательный, Расчетный, Карточный, Корреспондентский
        TBankAccountType = (BASavings, BACurrent, BACard, BACorrespondent);

        //типы банк счетов

        PBankAccountNode = ^TBankAccountNode;

        TBankAccountNode = Record
            Code: Integer;
            AccNumber: Integer;
            Balance: Currency;
            AccType: TBankAccountType;
            CollectionPercentage: Currency;
            Next, Prev: PBankAccountNode;
        End;

        TBankAccountList = Record
            Head, Tail: PBankAccountNode;
        End;

        //типы клиентов
        PClientNode = ^TClientNode;

        TClientNode = Record
            Code: Integer;
            SurName: String[15];
            Next, Prev: PClientNode;
        End;

        TClientList = Record
            Head, Tail: PClientNode;
        End;

    Public

        BankAccountList: TBankAccountList;
        ClientList: TClientList;
    End;

Var
    BankForm: TBankForm;

Const
    BA_STRING_ARRAY: Array [0 .. 3] Of String = ('Сберегательный', 'Расчётный', 'Карточный', 'Корреспондентский');
    CB_CHOICE_CLIENTS = 0;
    CB_CHOICE_ACCOUNTS = 1;

Implementation

{$R *.dfm}

Uses
    DevUnit,
    InstrUnit,
    AddEditUnit;

Procedure AddClient(Code: Integer; SurName: String);
Var
    PClient: TBankForm.PClientNode;
Begin

    New(PClient);
    PClient^.Code := Code;
    PClient^.SurName := SurName;
    PClient^.Next := Nil;
    PClient^.Prev := BankForm.ClientList.Tail;
    If BankForm.ClientList.Head = Nil Then
    Begin
        BankForm.ClientList.Tail := PClient;
        BankForm.ClientList.Head := PClient;
    End
    Else
    Begin
        BankForm.ClientList.Tail.Next := PClient;
        BankForm.ClientList.Tail := PClient;
    End;

End;

Procedure TBankForm.DeleteAccount();
Begin
    //
End;

Procedure TBankForm.DeleteAllClientAccounts(ClientCode: Integer);
Begin
    //
End;

Procedure TBankForm.DeleteClient();
Var
    I: Integer;
    DelNode: PClientNode;
Begin
    If MessageBox(BankForm.Handle, 'Вы уверены, что хотите удалить клиента (также удалятся все счета, связанные с ним).', 'Удалить?',
        MB_ICONWARNING + MB_YESNO) = ID_YES Then
    Begin

        DelNode := ClientList.Head;
        For I := 2 To SGMain.Selection.Top Do
            DelNode := DelNode.Next;

        DeleteAllClientAccounts(DelNode^.Code);
        If (DelNode.Prev = Nil) And (DelNode.Next = Nil) Then
        Begin
            ClientList.Head := Nil;
            ClientList.Tail := Nil;
        End
        Else
            If DelNode.Prev = Nil Then
            Begin
                ClientList.Head := ClientList.Head.Next;
                DelNode.Next.Prev := Nil;
            End
            Else
                If DelNode.Next = Nil Then
                Begin
                    ClientList.Tail := ClientList.Tail.Prev;
                    DelNode.Prev.Next := Nil;
                End
                Else
                Begin
                    DelNode.Prev.Next := DelNode.Next;
                    DelNode.Next.Prev := DelNode.Prev;
                End;
        Dispose(DelNode);
        ShowClients();

    End;
End;

Procedure TBankForm.ShowClients();
Var
    TempNodePointer: PClientNode;
    I: Integer;
Begin
    I := 1;
    If ClientList.Head = Nil Then
    Begin
        SGMain.Rows[1].Clear;
        SGMain.RowCount := 2;
        BitBtnDelete.Enabled := False;
        BitBtnEdit.Enabled := False;
    End
    Else
    Begin
        TempNodePointer := ClientList.Head;
        Repeat
        Begin
            SGMain.Cells[0, I] := IntToStr(TempNodePointer^.Code);
            SGMain.Cells[1, I] := TempNodePointer^.SurName;
            Inc(I);
            TempNodePointer := TempNodePointer.Next;
        End
        Until TempNodePointer = Nil;
        SGMain.RowCount := I;
        BitBtnDelete.Enabled := True;
        BitBtnEdit.Enabled := True;
    End;
End;

Procedure TBankForm.ShowBankAccounts();
Var
    TempNodePointer: PBankAccountNode;
    I: Integer;
Begin
    I := 1;
    If BankAccountList.Head = Nil Then
    Begin
        SGMain.Rows[2].Clear;
        SGMain.RowCount := 2;
        BitBtnDelete.Enabled := False;
        BitBtnEdit.Enabled := False;
    End
    Else
    Begin
        TempNodePointer := BankAccountList.Head;
        Repeat
        Begin
            SGMain.Cells[0, I] := IntToStr(TempNodePointer^.Code);
            SGMain.Cells[1, I] := IntToStr(TempNodePointer^.AccNumber);
            SGMain.Cells[2, I] := CurrToStr(TempNodePointer^.Balance);
            SGMain.Cells[3, I] := BA_STRING_ARRAY[Ord(TempNodePointer^.AccType)];
            SGMain.Cells[4, I] := CurrToStr(TempNodePointer^.CollectionPercentage);
            Inc(I);
            TempNodePointer := TempNodePointer.Next;
        End
        Until TempNodePointer = Nil;
        SGMain.RowCount := I;
        BitBtnDelete.Enabled := True;
        BitBtnEdit.Enabled := True;
    End;
End;

Procedure TBankForm.WorkWithClients();
Begin
    //TODOshechka
    SGMain.ColCount := 2;
    SGMain.ColWidths[0] := 150;
    SGMain.Cells[0, 0] := 'Код';
    SGMain.ColWidths[1] := 450;
    SGMain.Cells[1, 0] := 'Фамилия';

    ShowClients;
    SGMain.Visible := True;
    BitBtnAdd.Enabled := True;
End;

Procedure TBankForm.WorkWithBankAccounts();
Begin
    //TODOshechka
    SGMain.ColCount := 5;
    SGMain.DefaultColWidth := 135;
    SGMain.Cells[0, 0] := 'Код';
    SGMain.Cells[1, 0] := 'Номер счета';
    SGMain.Cells[2, 0] := 'Баланс';
    SGMain.Cells[3, 0] := 'Тип счета';
    SGMain.ColWidths[4] := 60;
    SGMain.Cells[4, 0] := 'Сбор';

    ShowBankAccounts;
    SGMain.Visible := True;
    BitBtnAdd.Enabled := True;
End;

Procedure TBankForm.BitBtnAddClick(Sender: TObject);
Begin
    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
    Begin
        AddClient(123, '123'); //
        //ShowModal(AddForm);
        ShowClients;
    End;
End;

Procedure TBankForm.BitBtnDeleteClick(Sender: TObject);
Begin
    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
        DeleteClient
    Else
        If CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS Then
            DeleteAccount;

End;

Procedure TBankForm.CBChoiceChange(Sender: TObject);
Begin
    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
        WorkWithClients()
    Else
        WorkWithBankAccounts();
End;

Procedure TBankForm.FormCreate(Sender: TObject);
Begin
    BankAccountList.Head := Nil;
    BankAccountList.Tail := Nil;
    ClientList.Head := Nil;
    ClientList.Tail := Nil;
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

Procedure TBankForm.NDevClick(Sender: TObject);
Begin
    DevForm := TDevForm.Create(Self);
    DevForm.ShowModal();
    DevForm.Destroy;
    DevForm := Nil;
End;

Procedure TBankForm.NInstrClick(Sender: TObject);
Begin
    InstrForm := TInstrForm.Create(Self);
    InstrForm.ShowModal();
    InstrForm.Destroy;
    InstrForm := Nil;
End;

Procedure TBankForm.NOpenClick(Sender: TObject);
Begin
    //TODO: OpenFile
End;

Procedure TBankForm.NSaveClick(Sender: TObject);
Begin
    //TODO: SaveFile
End;

End.
