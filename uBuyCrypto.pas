unit uBuyCrypto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  //
  uDM, uCurrentuser, uAuditLog;

type
  TfrmBuyCrypto = class(TForm)
    pnlTop: TPanel;
    lblBuyTitle: TLabel;
    pnlCenter: TPanel;
    lblAssetCaption: TLabel;
    lblAsset: TLabel;
    lblPriceCaption: TLabel;
    lblPrice: TLabel;
    lblQuantityCaption: TLabel;
    edtQuantity: TEdit;
    lblTotalCaption: TLabel;
    lblTotal: TLabel;
    btnBuy: TButton;
    procedure edtQuantityChange(Sender: TObject);
    procedure btnBuyClick(Sender: TObject);
  private
    { Private declarations }
    FSelectedSymbol : String;
    FSelectedPrice  : Double;
    //
    procedure CalculateTotal();
  public
    { Public declarations }
    procedure OpenForAsset(const ASymbol : String; const APrice : Double);
  end;

var
  frmBuyCrypto: TfrmBuyCrypto;

implementation

{$R *.fmx}

{ TfrmBuyCrypto }

procedure TfrmBuyCrypto.btnBuyClick(Sender: TObject);
var
  Quantity, CurrentPrice, TotalCost, CurrentBalance : Double;
begin
  {Validate the Quantity}
  if Trim(edtQuantity.Text) = '' then
   begin
     ShowMessage('Please enter a quantity!');
     edtQuantity.SetFocus;
     Exit;
   end;
  //
  try
    Quantity := StrToFloat(edtQuantity.Text);
  Except on E : Exception do
   begin
     ShowMessage('Please enter a valid numeric quantity!');
     edtQuantity.SetFocus;
     Exit;
   end;
  end;
  //
  if Quantity <= 0 then
   begin
     ShowMessage('The quantity must be greater than 0.');
     edtQuantity.SetFocus;
     Exit;
   end;
  //
  try
    dmMain.FDConnection1.StartTransaction;
    //
    try
      {Get the current market price.}
      dmMain.FDQueryBuyCrypto.Close;
      dmMain.FDQueryBuyCrypto.SQL.Text := 'SELECT price ' +
                                          'FROM crypto_prices ' +
                                          'WHERE symbol = :symbol';
      dmMain.FDQueryBuyCrypto.ParamByName('symbol').AsString := FSelectedSymbol;
      dmMain.FDQueryBuyCrypto.Open;
      //
      if dmMain.FDQueryBuyCrypto.IsEmpty then
       begin
         dmMain.FDConnection1.Rollback;
         ShowMessage('Cryptocurrency price not found!');
         Exit;
       end;
      //
      CurrentPrice := dmMain.FDQueryBuyCrypto.FieldByName('price').AsFloat;
      {Calculate the total cost.}
      TotalCost := Quantity * CurrentPrice;
      //
      {Get the current wallet balance.}
      dmMain.FDQueryBuyCrypto.Close;
      dmMain.FDQueryBuyCrypto.SQL.Text := 'SELECT balance ' +
                                           'FROM wallets ' +
                                           'WHERE user_id = :user_id';
      dmMain.FDQueryBuyCrypto.ParamByName('user_id').AsInteger := TCurrentUser.UserID;
      dmMain.FDQueryBuyCrypto.Open;
      //
      if dmMain.FDQueryBuyCrypto.IsEmpty then
       begin
         dmMain.FDConnection1.Rollback;
         ShowMessage('Wallet not found!');
         Exit;
       end;
      //
      CurrentBalance := dmMain.FDQueryBuyCrypto.FieldByName('balance').AsFloat;
      //
      {Check the available balance.}
      if TotalCost > CurrentBalance then
       begin
         dmMain.FDConnection1.Rollback;
         ShowMessage('Insufficient funds!');
         Exit;
       end;
      //
      {Deduct money from wallet.}
      dmMain.FDQueryBuyCrypto.Close;
      dmMain.FDQueryBuyCrypto.SQL.Text := 'UPDATE wallets ' +
                                          'SET balance = balance - :amount ' +
                                          'WHERE user_id = :user_id ' +
                                          'AND balance >= :amount';
      dmMain.FDQueryBuyCrypto.ParamByName('amount').AsFloat := TotalCost;
      dmMain.FDQueryBuyCrypto.ParamByName('user_id').AsInteger := TCurrentUser.UserID;
      dmMain.FDQueryBuyCrypto.ExecSQL;
      //
      if dmMain.FDQueryBuyCrypto.RowsAffected = 0 then
       begin
         dmMain.FDConnection1.Rollback;
         ShowMessage('Unable to update wallet balance!');
         Exit;
       end;
      //
      {Add Crypto to user's assets.}
      dmMain.FDQueryBuyCrypto.Close;
      dmMain.FDQueryBuyCrypto.SQL.Text := 'INSERT INTO assets (user_id, asset_type, symbol, quantity) ' +
                                          'VALUES (:user_id, :asset_type, :symbol, :quantity) ' +
                                          'ON CONFLICT (user_id, symbol) ' +
                                          'DO UPDATE SET quantity = assets.quantity + EXCLUDED.quantity';
      dmMain.FDQueryBuyCrypto.ParamByName('user_id').AsInteger := TCurrentUser.UserID;
      dmMain.FDQueryBuyCrypto.ParamByName('asset_type').AsString := 'CRYPTO';
      dmMain.FDQueryBuyCrypto.ParamByName('symbol').AsString := FSelectedSymbol;
      dmMain.FDQueryBuyCrypto.ParamByName('quantity').AsFloat := Quantity;
      dmMain.FDQueryBuyCrypto.ExecSQL;
      //
      {Insert Transaction History.}
      dmMain.FDQueryBuyCrypto.Close;
      dmMain.FDQueryBuyCrypto.SQL.Text := 'INSERT INTO transactions ' +
                                          '(user_id, transaction_type, asset_symbol, amount) ' +
                                          'VALUES (:user_id, :transaction_type, :asset_symbol, :amount)';
      dmMain.FDQueryBuyCrypto.ParamByName('user_id').AsInteger := TCurrentUser.UserID;
      dmMain.FDQueryBuyCrypto.ParamByName('transaction_type').AsString := 'BUY';
      dmMain.FDQueryBuyCrypto.ParamByName('asset_symbol').AsString := FSelectedSymbol;
      dmMain.FDQueryBuyCrypto.ParamByName('amount').AsFloat := TotalCost;
      dmMain.FDQueryBuyCrypto.ExecSQL;
      //
      {Commit everything}
      dmMain.FDConnection1.Commit;
      //
      {Audit Logs}
      LogAudit(TCurrentUser.UserID, 'BUY', 'Bought ' + FormatFloat('#,##0.########', Quantity) + ' ' + FSelectedSymbol + ' for $' + FormatFloat('#,##0.00', TotalCost));
      ShowMessage('Purchase completed successfully!');
      edtQuantity.Text := '';
      lblTotal.Text := '$0.00';
      Close;
    Except on E : Exception do
     begin
       dmMain.FDConnection1.Rollback;
       Showmessage('Purchase failed: ' + E.Message);
     end;
    end;
  //
  Except on E : Exception do
   begin
     ShowMessage('Database transaction error: ' + E.Message);
   end;
  end;
end;

procedure TfrmBuyCrypto.CalculateTotal;
var
  Quantity, Total : Double;
begin
  lblTotal.Text := '$0.00';
  if Trim(edtQuantity.Text) = '' then
   begin
     Exit
   end;
  //
  try
    Quantity := StrToFloat(edtQuantity.Text);
  Except on E : Exception do
   begin
     Exit;
   end;
  end;
  //
  if Quantity <= 0 then
   begin
     Exit;
   end;
  //
  Total := Quantity * FSelectedPrice;
  lblTotal.Text := '$' + FormatFloat('#,##0.00', Total);
end;

procedure TfrmBuyCrypto.edtQuantityChange(Sender: TObject);
begin
  CalculateTotal();
end;

procedure TfrmBuyCrypto.OpenForAsset(const ASymbol: String; const APrice: Double);
begin
  FSelectedSymbol := ASymbol;
  FSelectedPrice  := APrice;
  //
  lblAsset.Text := FSelectedSymbol;
  lblPrice.Text := '$' + FormatFloat('#,##0.00', FSelectedPrice);
  edtQuantity.Text := '';
  lblTotal.Text := '$0.00';
  //
  Show;
end;

end.
