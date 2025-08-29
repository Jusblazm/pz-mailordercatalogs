-- MailOrderCatalogs_Hooks
MailOrderCatalogs_Hooks = MailOrderCatalogs_Hooks or {}

function MailOrderCatalogs_Hooks.wrapFunction(tbl, funcName)
    if not tbl["_original_" .. funcName] then
        tbl["_original_" .. funcName] = tbl[funcName]

        tbl[funcName] = function(...)
            local result = { tbl["_original_" .. funcName](...) }

            local hooks = MailOrderCatalogs_Hooks[funcName]
            if hooks then
                for _, hook in ipairs(hooks) do
                    local ok, err = pcall(hook, result, ...)
                    if not ok then
                        print("[MailOrderCatalogs] Error: Hook error in " .. funcName .. ": " .. tostring(err))
                    end
                end
            end
            -- return table.unpack(result)
        end
    end
end

function MailOrderCatalogs_Hooks.add(funcName, callback)
    MailOrderCatalogs_Hooks[funcName] = MailOrderCatalogs_Hooks[funcName] or {}
    table.insert(MailOrderCatalogs_Hooks[funcName], callback)
end