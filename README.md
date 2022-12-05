# r-announcefree

El recurso no esta terminado | The resource is not finished 

Dependencias | Dependencies

download and put it on your server : https://github.com/CherryozZ/qb-menu-default

Add to qb-core/client/functions.lua

QBCore.Table = {}

function QBCore.Table.SizeOf(t)
	local count = 0

	for _,_ in pairs(t) do
		count = count + 1
	end

	return count
end

Citizen.CreateThread(function()
	while true do
		local wait = 500
		local currTime = GetGameTimer()
		if #QBCore.TimeoutCallbacks > 0 then
			wait = 0
			for i=1, #QBCore.TimeoutCallbacks, 1 do
				if QBCore.TimeoutCallbacks[i] then
					if currTime >= QBCore.TimeoutCallbacks[i].time then
						QBCore.TimeoutCallbacks[i].cb()
						QBCore.TimeoutCallbacks[i] = nil
					end
				end
			end
		end
		Wait(wait)
	end
end)

QBCore.Math = {}

QBCore.Math.Round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

QBCore.Math.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

QBCore.SetTimeout = function(msec, cb)
	table.insert(QBCore.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #QBCore.TimeoutCallbacks
end

QBCore.ClearTimeout = function(i)
	QBCore.TimeoutCallbacks[i] = nil
end

QBCore.UI                        = {}
QBCore.UI.Menu                   = {}
QBCore.UI.Menu.RegisteredTypes   = {}
QBCore.UI.Menu.Opened            = {}


QBCore.UI.Menu.RegisterType = function(type, open, close)
	QBCore.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

QBCore.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		QBCore.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #QBCore.UI.Menu.Opened, 1 do
			if QBCore.UI.Menu.Opened[i] then
				if QBCore.UI.Menu.Opened[i].type == type and QBCore.UI.Menu.Opened[i].namespace == namespace and QBCore.UI.Menu.Opened[i].name == name then
					QBCore.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		QBCore.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setElements = function(newElements)
		menu.data.elements = newElements
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(QBCore.UI.Menu.Opened, menu)
	QBCore.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

QBCore.UI.Menu.Close = function(type, namespace, name)
	for i=1, #QBCore.UI.Menu.Opened, 1 do
		if QBCore.UI.Menu.Opened[i] then
			if QBCore.UI.Menu.Opened[i].type == type and QBCore.UI.Menu.Opened[i].namespace == namespace and QBCore.UI.Menu.Opened[i].name == name then
				QBCore.UI.Menu.Opened[i].close()
				QBCore.UI.Menu.Opened[i] = nil
			end
		end
	end
end

QBCore.UI.Menu.CloseAll = function()
	for i=1, #QBCore.UI.Menu.Opened, 1 do
		if QBCore.UI.Menu.Opened[i] then
			QBCore.UI.Menu.Opened[i].close()
			QBCore.UI.Menu.Opened[i] = nil
		end
	end
end

QBCore.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #QBCore.UI.Menu.Opened, 1 do
		if QBCore.UI.Menu.Opened[i] then
			if QBCore.UI.Menu.Opened[i].type == type and QBCore.UI.Menu.Opened[i].namespace == namespace and QBCore.UI.Menu.Opened[i].name == name then
				return QBCore.UI.Menu.Opened[i]
			end
		end
	end
end

QBCore.UI.Menu.GetOpenedMenus = function()
	return QBCore.UI.Menu.Opened
end

QBCore.UI.Menu.IsOpen = function(type, namespace, name)
	return QBCore.UI.Menu.GetOpened(type, namespace, name) ~= nil
end
