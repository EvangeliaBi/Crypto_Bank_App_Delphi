object dmMain: TdmMain
  Height = 436
  Width = 555
  PixelsPerInch = 120
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=PG'
      'Database=cryptobank'
      'User_Name=postgres'
      'Password=Evangelia98!'
      'Server=localhost')
    LoginPrompt = False
    Left = 72
    Top = 32
  end
  object FDQueryLogin: TFDQuery
    Connection = FDConnection1
    Left = 184
    Top = 32
  end
  object FDQueryWallet: TFDQuery
    Connection = FDConnection1
    Left = 448
    Top = 32
  end
  object FDQueryAssets: TFDQuery
    Connection = FDConnection1
    Left = 72
    Top = 128
  end
  object FDQueryTransactions: TFDQuery
    Connection = FDConnection1
    Left = 312
    Top = 32
  end
  object FDQueryDeposit: TFDQuery
    Connection = FDConnection1
    Left = 192
    Top = 128
  end
  object FDQueryWithdraw: TFDQuery
    Connection = FDConnection1
    Left = 320
    Top = 128
  end
  object FDQueryAuditLog: TFDQuery
    Connection = FDConnection1
    Left = 456
    Top = 128
  end
  object FDQueryUpdateProfile: TFDQuery
    Connection = FDConnection1
    Left = 72
    Top = 216
  end
  object FDQueryChangePassword: TFDQuery
    Connection = FDConnection1
    Left = 248
    Top = 216
  end
  object FDQueryCryptoPrices: TFDQuery
    Connection = FDConnection1
    Left = 416
    Top = 216
  end
  object FDQueryBuyCrypto: TFDQuery
    Connection = FDConnection1
    Left = 72
    Top = 304
  end
  object FDQuerySellCrypto: TFDQuery
    Connection = FDConnection1
    Left = 208
    Top = 304
  end
end
