# Delphi Fintech Banking Application

A desktop fintech banking application developed with Delphi FireMonkey (FMX) and PostgreSQL.

The application combines traditional wallet management with cryptocurrency portfolio and trading functionality. It is being developed as a portfolio project with emphasis on database-driven backend logic, transaction integrity, user session management and financial operations.

## Features

### Authentication & User Management
- User login and logout
- Session management
- Profile management
- Password change functionality
- Password hashing
- User-specific data access

### Wallet Management
- Wallet balance management
- Deposit functionality
- Withdraw functionality
- Transaction history
- Automatic dashboard balance refresh

### Audit & Security
- Audit log for important user actions
- Login and logout logging
- Deposit and withdrawal logging
- Buy and sell activity logging
- Password change logging

### Cryptocurrency
- Cryptocurrency market list
- Current cryptocurrency prices
- User cryptocurrency portfolio
- Portfolio valuation
- Buy cryptocurrency
- Sell cryptocurrency

### Database
- PostgreSQL database
- FireDAC database connectivity
- Relational data model
- Database transactions for financial operations
- User-specific wallet and asset management

## Tech Stack

- Delphi
- FireMonkey (FMX)
- Object Pascal
- PostgreSQL
- FireDAC
- SQL

## Architecture

The application follows a modular structure where UI forms, session management, database access and business operations are separated into different units.

Example modules:

- `uLogin`
- `uDashboard`
- `uAccount`
- `uDeposit`
- `uWithdraw`
- `uTransactions`
- `uMarkets`
- `uBuyCrypto`
- `uSellCrypto`
- `uCurrentUser`
- `uSession`
- `uAuditLog`
- `uPasswordUtils`
- `uDM`

## Financial Operations

Financial operations are implemented using database transactions to maintain consistency between related data such as:

- Wallet balances
- Cryptocurrency assets
- Transaction history

For example, a cryptocurrency purchase updates the wallet, updates the user's assets and creates a transaction record as part of the same database transaction.

## Project Status

This project is currently under active development.

The core banking, wallet, authentication, audit logging and cryptocurrency trading functionality has been implemented, while additional features and improvements are still being developed.

## Future Improvements

Planned improvements include:

- Improved portfolio analytics
- Profit & Loss calculations
- Transaction filtering and search
- Trading fees
- More advanced password security
- Real-time cryptocurrency market data through an external API
- Improved user interface and responsive layouts
- Additional security and validation mechanisms

## Disclaimer

This project is developed for educational and portfolio purposes.

It does not represent a real financial institution, trading platform or production financial service.
