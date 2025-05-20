program BankSystem;





uses
  Vcl.Forms,
  BankSystemUnit in 'BankSystemUnit.pas' {BankForm},
  AddEditUnit in 'AddEditUnit.pas' {AddEditForm},
  DevUnit in 'DevUnit.pas',
  InstrUnit in 'InstrUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBankForm, BankForm);
  Application.CreateForm(TAddEditForm, AddEditForm);
  Application.Run;
end.
