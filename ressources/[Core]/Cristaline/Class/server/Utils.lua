__Utils = {}

function __Utils:identifier(source)
    return string.gsub(GetPlayerIdentifierByType(source, 'license'), 'license:', '')
end