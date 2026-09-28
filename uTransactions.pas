unit uTransactions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView,
  //
  uDM, uCurrentUser;

type
  TfrmTransactions = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    ListViewTransactions: TListView;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTransactions();
  public
    { Public declarations }
  end;

var
  frmTransactions: TfrmTransactions;

implementation

{$R *.fmx}

{ TfrmTransactions }

procedure TfrmTransactions.FormShow(Sender: TObject);
begin
  LoadTransactions;
end;

procedure TfrmTransactions.LoadTransactions;
begin
  ListViewTransactions.Items.Clear;
  //
  dmMain.FDQueryTransactions.Close;
  dmMain.FDQueryTransactions.SQL.Text := 'SELECT transaction_type, asset_symbol, amount, transaction_date ' +
                                          'FROM transactions ' +
                                          'WHERE user_id = :user_id ' +
                                          'ORDER BY transaction_date DESC';
  dmMain.FDQueryTransactions.ParamByName('user_id').AsInteger := TCurrentUser.UserID;
  dmMain.FDQueryTransactions.Open;
  //
  while not dmMain.FDQueryTransactions.Eof do
    begin
      ListViewTransactions.Items.Add.Text := dmMain.FDQueryTransactions.FieldByName('transaction_type').AsString + ' ' + dmMain.FDQueryTransactions.FieldByName('asset_symbol').AsString + ' (' + dmMain.FDQueryTransactions.FieldByName('amount').AsString + ')';
      dmMain.FDQueryTransactions.Next;
    end;
end;

end.
