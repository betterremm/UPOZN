program BankSystem;





uses
  Vcl.Forms,
  BankSystemUnit in 'BankSystemUnit.pas' {BankForm},
  AddEditClientUnit in 'AddEditClientUnit.pas' {AddEditClientForm},
  DevUnit in 'DevUnit.pas',
  InstrUnit in 'InstrUnit.pas',
  AddEditBankAccountUnit in 'AddEditBankAccountUnit.pas' {AddEditBankAccountForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBankForm, BankForm);
  Application.CreateForm(TAddEditBankAccountForm, AddEditBankAccountForm);
  Application.Run;
end.
