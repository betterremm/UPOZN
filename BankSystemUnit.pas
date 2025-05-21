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
    TBankAccountType = (BASavings, BACurrent, BACard, BACorrespondent);

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
    LbComboBox: TLabel;
    temp: TLabel;
    BitBtnShowAccounts: TBitBtn;
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
        Function IsClientUnique(Code: Integer): Boolean;
        Function IsAccountUnique(AccNumber: Integer): Boolean;
        Procedure SGMainSelectCell(Sender: TObject; ACol, ARow: LongInt; Var CanSelect: Boolean);
        Procedure BitBtnEditClick(Sender: TObject);
        Procedure AddClient(Code: Integer; SurName: String);
        Procedure AddBankAccount(Code, AccNumber: Integer; Balance: Currency; AccType: TBankAccountType; CollectionPercentage: Currency);
        Function DoesClientHaveBankAccount(Code: Integer): Boolean;
        Procedure ChangeAllBankAccountCodes(Target, Replacement: Integer);
        Procedure ChangeClientCode(Target, Replacement: Integer);

    Private
    { Private declarations }

        Type
        //Сберегательный, Расчетный, Карточный, Корреспондентский


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

    Public Const
        MaxCollectionPercentage = 1000;

    Var
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
    AddEditClientUnit,
    AddEditBankAccountUnit;

Procedure TBankForm.ChangeClientCode(Target, Replacement: Integer);
Var
    TempClientNode: PClientNode;
Begin
    TempClientNode := ClientList.Head;
    While TempClientNode <> Nil Do
    Begin
        If TempClientNode^.Code = Target Then
            TempClientNode^.Code := Replacement;
        TempClientNode := TempClientNode^.Next;
    End;
End;

Procedure TBankForm.ChangeAllBankAccountCodes(Target, Replacement: Integer);
Var
    TempBankAccountNode: PBankAccountNode;
Begin
    TempBankAccountNode := BankAccountList.Head;
    While TempBankAccountNode <> Nil Do
    Begin
        If TempBankAccountNode^.Code = Target Then
            TempBankAccountNode^.Code := Replacement;
        TempBankAccountNode := TempBankAccountNode.Next;
    End;
End;

Function TBankForm.IsClientUnique(Code: Integer): Boolean;
Var
    IsUnique: Boolean;
    TempNode: PClientNode;
Begin
    IsUnique := True;
    TempNode := ClientList.Head;
    While (TempNode <> Nil) And IsUnique Do
    Begin
        If TempNode.Code = Code Then
            IsUnique := False
        Else
            TempNode := TempNode^.Next;
    End;
    IsClientUnique := IsUnique;
End;

Function TBankForm.IsAccountUnique(AccNumber: Integer): Boolean;
Var
    IsUnique: Boolean;
    TempNode: PBankAccountNode;
Begin
    IsUnique := True;
    TempNode := BankAccountList.Head;
    While (TempNode <> Nil) And IsUnique Do
    Begin
        If TempNode.AccNumber = AccNumber Then
            IsUnique := False
        Else
            TempNode := TempNode^.Next;
    End;
    IsAccountUnique := IsUnique;
End;

Procedure TBankForm.AddClient(Code: Integer; SurName: String);
Var
    PClient: TBankForm.PClientNode;
Begin

    If IsClientUnique(Code) Then
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
    End
    Else
        MessageBox(BankForm.Handle, 'Клиент с таким кодом уже существует!', 'Внимание', MB_ICONWARNING + MB_OK);

End;

Procedure TBankForm.AddBankAccount(Code, AccNumber: Integer; Balance: Currency; AccType: TBankAccountType; CollectionPercentage: Currency);
Var
    PAccount: TBankForm.PBankAccountNode;
Begin

    If IsAccountUnique(AccNumber) Then
    Begin
        New(PAccount);
        PAccount^.Code := Code;
        PAccount^.AccNumber := AccNumber;
        PAccount^.Balance := Balance;
        PAccount^.AccType := AccType;
        PAccount^.CollectionPercentage := CollectionPercentage;
        PAccount^.Next := Nil;
        PAccount^.Prev := BankForm.BankAccountList.Tail;
        If BankForm.BankAccountList.Head = Nil Then
        Begin
            BankForm.BankAccountList.Tail := PAccount;
            BankForm.BankAccountList.Head := PAccount;
        End
        Else
        Begin
            BankForm.BankAccountList.Tail.Next := PAccount;
            BankForm.BankAccountList.Tail := PAccount;
        End;
    End
    Else
        MessageBox(BankForm.Handle, 'Счет с таким номером уже существует!', 'Внимание', MB_ICONWARNING + MB_OK);
End;

Procedure DeleteAccountNode(DelNode: TBankForm.PBankAccountNode);
Begin
    If (DelNode.Prev = Nil) And (DelNode.Next = Nil) Then
    Begin
        BankForm.BankAccountList.Head := Nil;
        BankForm.BankAccountList.Tail := Nil;
    End
    Else
        If DelNode.Prev = Nil Then
        Begin
            BankForm.BankAccountList.Head := BankForm.BankAccountList.Head.Next;
            DelNode.Next.Prev := Nil;
        End
        Else
            If DelNode.Next = Nil Then
            Begin
                BankForm.BankAccountList.Tail := BankForm.BankAccountList.Tail.Prev;
                DelNode.Prev.Next := Nil;
            End
            Else
            Begin
                DelNode.Prev.Next := DelNode.Next;
                DelNode.Next.Prev := DelNode.Prev;
            End;
    Dispose(DelNode);
End;

Function TBankForm.DoesClientHaveBankAccount(Code: Integer): Boolean;
Var
    TempNode: PBankAccountNode;
    NotFound: Boolean;
Begin
    NotFound := True;
    TempNode := BankAccountList.Head;
    While (TempNode <> Nil) And NotFound Do
    Begin
        If TempNode^.Code = Code Then
            NotFound := False;
        TempNode := TempNode.Next;
    End;

End;

Procedure TBankForm.DeleteAccount();
Var
    DelNode: PBankAccountNode;
    I: Integer;
Begin
    If MessageBox(BankForm.Handle, 'Вы уверены, что хотите удалить банковский аккаунт?', 'Удалить?', MB_ICONWARNING + MB_YESNO)
        = ID_YES Then
    Begin
        DelNode := BankAccountList.Head;
        For I := 2 To SGMain.Selection.Top Do
            DelNode := DelNode.Next;
        DeleteAccountNode(DelNode);
        ShowBankAccounts();
    End;
End;

Procedure TBankForm.DeleteAllClientAccounts(ClientCode: Integer);
Var
    DelNode, TempNode: PBankAccountNode;
    I: Integer;
Begin
    DelNode := BankAccountList.Head;
    Repeat
        If DelNode^.Code = ClientCode Then
        Begin
            TempNode := DelNode^.Next;
            DeleteAccountNode(DelNode);
            DelNode := TempNode;
        End
        Else
            DelNode := DelNode^.Next;
    Until DelNode = Nil;
End;

Procedure TBankForm.DeleteClient();
Var
    I: Integer;
    DelNode: PClientNode;
    TempNode: PBankAccountNode;

Begin
    If MessageBox(BankForm.Handle, 'Вы уверены, что хотите удалить клиента?', 'Удалить?', MB_ICONWARNING + MB_YESNO) = ID_YES Then
    Begin
        DelNode := ClientList.Head;
        For I := 2 To SGMain.Selection.Top Do
            DelNode := DelNode.Next;

        If DoesClientHaveBankAccount(DelNode^.Code) And (MessageBox(BankForm.Handle, 'Вы желаете вместе с клиентом удалить все его счета?',
            'Удалить?', MB_ICONWARNING + MB_YESNO) = ID_YES) Then
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
    End;
End;

Procedure TBankForm.SGMainSelectCell(Sender: TObject; ACol, ARow: LongInt; Var CanSelect: Boolean);
Begin
    If ((CBChoice.ItemIndex = CB_CHOICE_CLIENTS) And (ClientList.Head <> Nil)) Or
        ((CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS) And (BankAccountList.Head <> Nil)) Then
    Begin
        BitBtnDelete.Enabled := True;
        BitBtnEdit.Enabled := True;
    End
    Else
    Begin
        BitBtnDelete.Enabled := False;
        BitBtnEdit.Enabled := True;
    End
End;

Procedure TBankForm.ShowBankAccounts();
Var
    TempNodePointer: PBankAccountNode;
    I: Integer;
Begin
    I := 1;
    If BankAccountList.Head = Nil Then
    Begin
        SGMain.Rows[1].Clear;
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
            SGMain.Cells[2, I] := CurrToStr(TempNodePointer^.Balance) + ' р.';
            SGMain.Cells[3, I] := BA_STRING_ARRAY[Ord(TempNodePointer^.AccType)];
            SGMain.Cells[4, I] := CurrToStr(TempNodePointer^.CollectionPercentage) + '%';
            Inc(I);
            TempNodePointer := TempNodePointer.Next;
        End
        Until TempNodePointer = Nil;
        SGMain.RowCount := I;
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
        AddEditClientForm := TAddEditClientForm.Create(Self);
        AddEditClientForm.ShowModal();
        If AddEditClientForm.ClosedByButton Then
            AddClient(StrToInt(AddEditClientForm.EditCode.Text), AddEditClientForm.EditSurname.Text);
        AddEditClientForm.Destroy;
        AddEditClientForm := Nil;
        ShowClients;
    End
    Else
        If CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS Then
        Begin
            AddEditBankAccountForm := TAddEditBankAccountForm.Create(Self);
            AddEditBankAccountForm.ShowModal();
            If AddEditBankAccountForm.ClosedByButton Then
                With AddEditBankAccountForm Do
                Begin
                    AddBankAccount(StrToInt(EditCode.Text), StrToInt(EditAccNumber.Text), StrToCurr(EditBalance.Text),
                        TBankAccountType(CBType.ItemIndex), StrToCurr(EditCollectionPercentage.Text));
                End;
            AddEditBankAccountForm.Destroy;
            AddEditBankAccountForm := Nil;
            ShowBankAccounts;
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

Procedure TBankForm.BitBtnEditClick(Sender: TObject);
Var
    I: Integer;
    TempClientPointer: PClientNode;
    TempBankAccountPointer: PBankAccountNode;
Begin
    //TODOTODOTODOTODO
    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
        With AddEditClientForm Do
        Begin

            AddEditClientForm := TAddEditClientForm.Create(Self);
            TempClientPointer := ClientList.Head;
            For I := 2 To SGMain.Selection.Top Do
                TempClientPointer := TempClientPointer.Next;

            EditCode.Text := IntToStr(TempClientPointer^.Code);
            EditSurname.Text := TempClientPointer^.Surname;
            IsFilled[1] := True;
            IsFilled[2] := True;
            BtnAccept.Enabled := True;
            ShowModal();
            If ClosedByButton Then
            Begin
                If (StrToInt(EditCode.Text) = TempClientPointer^.Code) Or IsClientUnique(StrToInt(EditCode.Text)) Then
                Begin
                    If (StrToInt(EditCode.Text) <> TempClientPointer^.Code) And DoesClientHaveBankAccount(TempClientPointer^.Code) And
                        (MessageBox(BankForm.Handle, 'Вы желаете так же изменить все аккаунты принадлежащие данному клиенту?', 'Изменить?',
                        MB_ICONWARNING + MB_YESNO) = ID_YES) Then
                        ChangeAllBankAccountCodes(TempClientPointer^.Code, StrToInt(EditCode.Text));
                    TempClientPointer^.Code := StrToInt(EditCode.Text);
                    TempClientPointer^.SurName := EditSurName.Text;
                End
                Else
                    MessageBox(BankForm.Handle, 'Изменения не были применены, клиент с таким номером уже существует.', 'Внимание!',
                        MB_ICONWARNING + MB_OK);

            End;
            Destroy;
            AddEditClientForm := Nil;
            ShowClients;
        End
    Else
        If CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS Then
            With AddEditBankAccountForm Do
            Begin
                AddEditBankAccountForm := TAddEditBankAccountForm.Create(Self);
                TempBankAccountPointer := BankAccountList.Head;
                For I := 2 To SGMain.Selection.Top Do
                    TempBankAccountPointer := TempBankAccountPointer.Next;

                EditCode.Text := IntToStr(TempBankAccountPointer^.Code);
                EditAccNumber.Text := IntToStr(TempBankAccountPointer^.AccNumber);
                EditBalance.Text := CurrToStr(TempBankAccountPointer^.Balance);
                CBType.ItemIndex := Ord(TempBankAccountPointer^.AccType);
                EditCollectionPercentage.Text := CurrToStr(TempBankAccountPointer^.CollectionPercentage);
                IsFilled[1] := True;
                IsFilled[2] := True;
                IsFilled[3] := True;
                IsFilled[4] := True;
                IsFilled[5] := True;
                BtnAccept.Enabled := True;
                ShowModal();
                If ClosedByButton Then
                Begin
                    If (StrToInt(EditAccNumber.Text) = TempBankAccountPointer^.AccNumber) Or
                        IsAccountUnique(StrToInt(EditAccNumber.Text)) Then
                    Begin
                        If (StrToInt(EditCode.Text) <> TempBankAccountPointer^.Code) And Not IsClientUnique(TempBankAccountPointer^.Code)
                            And (MessageBox(BankForm.Handle, 'Вы желаете так же изменить код клиента владельца аккаунта?', 'Изменить?',
                            MB_ICONWARNING + MB_YESNO) = ID_YES) Then
                            ChangeClientCode(TempBankAccountPointer^.Code, StrToInt(EditCode.Text));
                        TempBankAccountPointer^.Code := StrToInt(EditCode.Text);
                        TempBankAccountPointer^.AccNumber := StrToInt(EditAccNumber.Text);
                        TempBankAccountPointer^.Balance := StrToCurr(EditBalance.Text);
                        TempBankAccountPointer^.AccType := TBankAccountType(CBType.ItemIndex);
                        TempBankAccountPointer^.CollectionPercentage := StrToCurr(EditCollectionPercentage.Text);
                    End
                    Else
                        MessageBox(BankForm.Handle, 'Изменения не были применены, аккаунт с таким номером уже существует.', 'Внимание!',
                            MB_ICONWARNING + MB_OK);

                End;
                Destroy;
                AddEditClientForm := Nil;
                ShowBankAccounts;
            End;

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
