local g_Db = {}
local sqlite3 = _require("lsqlite3")
if not sqlite3 then
    return
end

local dbDir = device.writablePath .. "files/db/"
local dbName = "db"
local database

g_Db.dataType = {
    INT = "INTEGER", --整型
    TEXT = "TEXT", --文本
    REAL = "REAL", --浮点
    BLOB = "BLOB", --未定义
    NUM = "NUMERIC" --时间，布尔
}

g_Db.modType = {
    PRIKEY = "PRIMARY KEY", --主键
    AUTO = "AUTOINCREMENT" --自增
}

g_Db.orderType = {
    ASC = "ASC", --正序
    DESC = "DESC" --倒序
}

function g_Db.open()
    if database then
        return database
    end
    g_FileUtils.checkDir(dbDir)
    database = sqlite3.open(dbDir .. dbName)
    return database
end

function g_Db.close()
    if database then
        local status = database:close()
        database = nil
        return status == sqlite3.OK
    end
    print("database is nil")
    return false
end

--[[
    @desc: 
    author:BogeyRuan
    time:2019-04-01 14:25:21
    --@sql:
	--@func: 查询时每行回调，接受4个参数(udata, cols, values, names)
	--@udata: 自定义数据，在回调参数中使用
    @return:
]]
function g_Db.exec(sql, func, udata)
    if database then
        return database:exec(sql, func, udata) == sqlite3.OK
    end
    print("database is nil")
    return false
end

--[[
    @desc: 创建表
    author:BogeyRuan
    time:2019-04-01 11:53:12
    --@tableName: 表名称
    --@params: 各字段
	--@isNew: 是否生成新的表
    @return:

    local params = {
        [1] = {"id", g_Db.dataType.INT, g_Db.modType.PRIKEY},
        [2] = {"name", g_Db.dataType.TEXT},
    }
    g_Db.open()
    g_Db.create("user", params)
    g_Db.close()
]]
function g_Db.create(tableName, params, isNew)
    if database then
        if isNew then
            if not g_Db.exec("DROP TABLE IF EXISTS " .. tableName) then
                return false
            end
        end
        local sql = "CREATE TABLE IF NOT EXISTS " .. tableName .. "("
        for i, v in ipairs(params) do
            table.insert(v, 1, sql)
            sql = table.concat(v, " ")
            if i ~= #params then
                sql = sql .. ","
            end
        end
        sql = sql .. ")"
        return g_Db.exec(sql)
    end
    return false
end

--[[
    @desc: 查询数据
    author:BogeyRuan
    time:2019-04-01 14:20:11
    --@tableName: 表名称
	--@where: 条件，可以多条件 {{key:string, value:string, con:"= >= <= > <"}}
	--@order: 排序 {key, ASC | DESC}
	--@limit: 分页，startIdx从0开始 {[startIdx,] num}
    @return: 

    g_Db.open()
    g_Db.create("user",{
        [1] = {"id", g_Db.dataType.INT, g_Db.modType.PRIKEY},
        [2] = {"name", g_Db.dataType.TEXT}
    })
    g_Db.insert("user", {id = 1, name = "a"})
    g_Db.insert("user", {id = 2, name = "b"})
    g_Db.insert("user", {id = 3, name = "c"})
    g_Db.insert("user", {id = 4, name = "a"})
    g_Db.insert("user", {id = 5, name = "b"})
    g_Db.insert("user", {id = 6, name = "c"})
    local data = g_Db.query("user", {{"name", "a"}}, {"id", g_Db.orderType.DESC}, {0, 1})
    g_Db.close()
    dump(data)
    ------------------------
    data = {
        [1] = {
            id = 4,
            name = "a"
        }
    }
]]
function g_Db.query(tableName, where, order, limit)
    if database then
        local sql = "SELECT * FROM " .. tableName
        if where then
            local con = " WHERE"
            for i, v in ipairs(where) do
                local key = '"' .. v[1] .. '"'
                local value = '"' .. v[2] .. '"'
                local conditions = v[3] or "="
                con = table.concat({con, key, conditions, value}, " ")
                if i ~= #where then
                    con = con .. " AND"
                end
            end
            sql = sql .. con
        end
        if order then
            local con = " ORDER BY "
            local key = '"' .. order[1] .. '"'
            local seq = order[2] or g_Db.orderType.ASC
            con = con .. key .. " " .. seq
            sql = sql .. con
        end
        if limit then
            local startIdx = limit[1]
            local num = limit[2]
            if not num then
                sql = sql .. " LIMIT " .. startIdx
            else
                sql = sql .. " LIMIT " .. startIdx .. ", " .. num
            end
        end
        local data = {}
        for temp in database:nrows(sql) do
            table.insert(data, temp)
        end
        return data
    end
    return {}
end

--[[
    @desc: 插入单条数据
    author:BogeyRuan
    time:2019-04-01 15:24:54
    --@tableName: 表名称
	--@data: 数据 {key = value, ...}
    @return:
    
    g_Db.open()
    g_Db.insert("user", {id = 7, name = "a"})
    g_Db.close()
]]
function g_Db.insert(tableName, data)
    if database then
        local sql = "INSERT INTO " .. tableName
        local keys = ""
        local values = ""
        local totalCount = 2
        local index = 1
        for k, v in pairs(data) do
            keys = keys .. k
            values = values .. '"' .. v .. '"'
            if index ~= totalCount then
                keys = keys .. ","
                values = values .. ","
            end
            index = index + 1
        end
        sql = sql .. " (" .. keys .. ") VALUES (" .. values .. ")"
        return g_Db.exec(sql)
    end
    return false
end

--[[
    @desc: 修改已存在数据
    author:BogeyRuan
    time:2019-04-01 16:41:08
    --@tableName: 表名称
	--@where: 条件，可以多条件 {{key:string, value:string, con:"= >= <= > <"}}
	--@data: 数据 {key = value, ...}
    @return:

    g_Db.open()
    g_Db.update("user", {{"id", 1}}, {name = "aa"})
    g_Db.close()
]]
function g_Db.update(tableName, where, data)
    if database then
        local sql = "UPDATE " .. tableName .. " SET "
        for k, v in pairs(data) do
            sql = table.concat({sql, k, "=", '"' .. v .. '"', ","})
        end
        sql = string.sub(sql, 1, -2)
        if where then
            local con = " WHERE"
            for i, v in ipairs(where) do
                local key = '"' .. v[1] .. '"'
                local value = '"' .. v[2] .. '"'
                local conditions = v[3] or "="
                con = table.concat({con, key, conditions, value}, " ")
                if i ~= #where then
                    con = con .. " AND"
                end
            end
            sql = sql .. con
        end
        return g_Db.exec(sql)
    end
    return false
end

--[[
    @desc: 替换数据，之前存在主键相同的数据则更新，不存在则添加
    author:BogeyRuan
    time:2019-04-01 16:51:20
    --@tableName: 表名称
	--@data: 数据 {key = value, ...}
    @return:

    g_Db.open()
    g_Db.repalce("user", {id = 1, name = "aa"})
    g_Db.repalce("user", {id = 8, name = "b"})
    g_Db.close()
]]
function g_Db.repalce(tableName, data)
    if database then
        local sql = "REPLACE INTO " .. tableName
        local keys = ""
        local values = ""
        local totalCount = 2
        local index = 1
        for k, v in pairs(data) do
            keys = keys .. k
            values = values .. '"' .. v .. '"'
            if index ~= totalCount then
                keys = keys .. ","
                values = values .. ","
            end
            index = index + 1
        end
        sql = sql .. " (" .. keys .. ") VALUES (" .. values .. ")"
        return g_Db.exec(sql)
    end
    return false
end

--[[
    @desc: 删除数据
    author:BogeyRuan
    time:2019-04-01 17:01:17
    --@tableName: 表名称
	--@where: 条件，可以多条件 {{key:string, value:string, con:"= >= <= > <"}}
    @return:
    
    g_Db.open()
    g_Db.delete("user", {{"id", 1}})
    g_Db.close()
]]
function g_Db.delete(tableName, where)
    if database then
        local sql = "DELETE FROM " .. tableName
        if where then
            local con = " WHERE"
            for i, v in ipairs(where) do
                local key = '"' .. v[1] .. '"'
                local value = '"' .. v[2] .. '"'
                local conditions = v[3] or "="
                con = table.concat({con, key, conditions, value}, " ")
                if i ~= #where then
                    con = con .. " AND"
                end
            end
            sql = sql .. con
        end
        return g_Db.exec(sql)
    end
    return false
end

return g_Db
