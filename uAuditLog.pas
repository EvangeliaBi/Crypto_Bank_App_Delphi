unit uAuditLog;

interface

procedure LogAudit(const AUserID : Integer; const AAction : string; const ADescription : string);

implementation

uses
 uDM;

procedure LogAudit(const AUserID : Integer; const AAction : string; const ADescription : string);
  begin
    if AUserID <= 0 then
     begin
       Exit;
     end;
    //
    dmMain.FDQueryAuditLog.Close;
    dmMain.FDQueryAuditLog.SQL.Text := 'INSERT INTO audit_logs ' +
                                       '(user_id, action, description) ' +
                                       'VALUES (:user_id, :action, :description)';
    dmMain.FDQueryAuditLog.ParamByName('user_id').AsInteger := AUserID;
    dmMain.FDQueryAuditLog.ParamByName('action').AsString := AAction;
    dmMain.FDQueryAuditLog.ParamByName('description').AsString := ADescription;
    dmMain.FDQueryAuditLog.ExecSQL;
  end;
end.
