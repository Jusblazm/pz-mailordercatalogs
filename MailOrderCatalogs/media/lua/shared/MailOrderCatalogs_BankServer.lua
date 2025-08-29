-- MailOrderCatalogs_BankServer
MailOrderCatalogs_BankServer = {}

function MailOrderCatalogs_BankServer.getAccountID(player)
    local steamID = player:getSteamID()
    local characterName = player:getFullName()

    return steamID .. "_" .. characterName
end

function MailOrderCatalogs_BankServer.ensureData()
    local bankData = ModData.get("BankAccounts")
    if not bankData then
        ModData.add("BankAccounts", {accounts = {}})
        bankData = ModData.get("BankAccounts")
    elseif not bankData.accounts then
        bankData.accounts = {}
    end
    return bankData
end

function MailOrderCatalogs_BankServer.getOrCreateAccount(player)
    local bankData = MailOrderCatalogs_BankServer.ensureData()
    local id = MailOrderCatalogs_BankServer.getAccountID(player)

    if not bankData.accounts[id] then
        bankData.accounts[id] = {
            accountID = id,
            balance = 0,
            pin = "11",
            owner = player:getFullName(),
            isStolen = false,
            attempts = 0
        }
        ModData.transmit("BankAccounts")
    end
    return bankData.accounts[id]
end

function MailOrderCatalogs_BankServer.getOrCreateAccountByID(card)
    local bankData = MailOrderCatalogs_BankServer.ensureData()
    local id = card.accountID
    local owner = card.owner
    local pin = card.pin
    local isStolen = card.isStolen
    local attempts = card.attempts
    if not bankData.accounts[id] then
        local isFakeCard = id:sub(1, 5) == "FAKE_"
        local startingBalance = isFakeCard and ZombRand(5, 501) or 0

        bankData.accounts[id] = {
            accountID = id,
            balance = startingBalance,
            pin = pin or "Unknown",
            owner = owner or "Unknown",
            isStolen = isStolen or false,
            attempts = attempts or 0
        }
        ModData.transmit("BankAccounts")
    else
        bankData.accounts[id].pin = card.pin or "Unknown"
    end
    return bankData.accounts[id]
end

function MailOrderCatalogs_BankServer.getAccountByID(id)
    local bankData = MailOrderCatalogs_BankServer.ensureData()
    return bankData.accounts[id]
end

function MailOrderCatalogs_BankServer.deposit(accountID, amount)
    if not amount or amount <= 0 then return false end

    local account = MailOrderCatalogs_BankServer.getAccountByID(accountID)
    if not account then return false end

    account.balance = account.balance + amount
    ModData.transmit("BankAccounts")
    return true
end

function MailOrderCatalogs_BankServer.withdraw(accountID, amount)
    if not amount or amount <= 0 then return false end

    local account = MailOrderCatalogs_BankServer.getAccountByID(accountID)
    if not account then return false end
    if account.balance < amount then return false end

    account.balance = account.balance - amount
    ModData.transmit("BankAccounts")
    return true
end

function MailOrderCatalogs_BankServer.getBalance(card)
    local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(card)
    return account.balance or 0
end

function MailOrderCatalogs_BankServer.setBalance(card, newBalance)
    local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(card)
    account.balance = newBalance
    ModData.transmit("BankAccounts")
    return true
end


function MailOrderCatalogs_BankServer.getPIN(card)
    local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(card)
    return account.pin or "Unknown"
end

function MailOrderCatalogs_BankServer.setPIN(card, newPin)
    local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(card)
    account.pin = newPin
    ModData.transmit("BankAccounts")
end

function MailOrderCatalogs_BankServer.printAllAccounts()
    local bankData = MailOrderCatalogs_BankServer.ensureData()
    print("=== All Bank Accounts ===")
    for id, account in pairs(bankData.accounts) do
        print("Account ID: ", id)
        print("Owner: ", account.owner)
        print("Balance: $", account.balance)
        print("PIN: ", account.pin)
        print("---------------------------")
    end
end

return MailOrderCatalogs_BankServer