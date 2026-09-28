unit uCurrentUser;

interface

type
  TCurrentUser = class
    public
      class var UserID    : Integer;
      class var Email     : String;
      class var FirstName : String;
      class var LastName  : String;

      class procedure Clear(); static;
      class function IsLoggedIn() : Boolean; static;
  end;

implementation

{ TCurrentUser }

class procedure TCurrentUser.Clear();
begin
  UserID    := 0;
  Email     := '';
  FirstName := '';
  LastName  := '';
end;

class function TCurrentUser.IsLoggedIn() : Boolean;
begin
  Result := UserID > 0;
end;

end.
