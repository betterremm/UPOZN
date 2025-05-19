program BankSystem;

uses
  Vcl.Forms,
  UserProgramUnit in 'UserProgramUnit.pas' {UserProgramForm},
  WatchListsUnit in 'WatchListsUnit.pas' {WatchListsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUserProgramForm, UserProgramForm);
  Application.CreateForm(TWatchListsForm, WatchListsForm);
  Application.Run;
end.
