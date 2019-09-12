function io.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

function io.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

function io.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

function io.formatPath(path)
    path = string.gsub(path, "[/\\]", "\\\\")
    path = string.gsub(path, "[/\\]*$", "")
    return path
end

function io.mkdir(path)
    if not io.exists(path) then
        return os.execute("mkdir " .. io.formatPath(path))
    end
    return true
end

function io.rmdir(path)
    if io.exists(path) then
        return os.execute("rmdir /s/q " .. io.formatPath(path))
    end
end

function string.lowerFirst(str)
    return string.lower(string.sub(str, 1, 1)) .. string.sub(str, 2, -1)
end

function string.upperFirst(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2, -1)
end