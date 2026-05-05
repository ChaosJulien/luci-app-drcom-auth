module("luci.controller.drcom_auth", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/drcom-auth") then
        return
    end

    entry({"admin", "services", "drcom_auth"}, firstchild(), _("校园网认证"), 60).dependent = false
    entry({"admin", "services", "drcom_auth", "overview"}, call("action_overview"), _("概览"), 10).leaf = true
    entry({"admin", "services", "drcom_auth", "config"}, cbi("drcom_auth/config"), _("配置"), 20).leaf = true
    entry({"admin", "services", "drcom_auth", "action"}, call("action_exec"), nil).leaf = true
    entry({"admin", "services", "drcom_auth", "logs"}, call("action_logs"), nil).leaf = true
end

local sys = require "luci.sys"
local http = require "luci.http"
local util = require "luci.util"
local fs = require "nixio.fs"
local uci = require "luci.model.uci".cursor()

function service_running()
    return sys.call("/etc/init.d/drcom-auth status >/dev/null 2>&1") == 0
end

function read_state()
    local state = { last_time = "-", last_status = "-", last_message = "-" }
    local path = "/var/run/drcom-auth-watchdog.state"
    if fs.access(path) then
        local txt = fs.readfile(path) or ""
        for k, v in txt:gmatch("([%w_]+)=([^\n]*)") do
            state[k] = v
        end
    end
    return state
end

function action_overview()
    local data = {}
    data.running = service_running() and "运行中" or "未运行"
    data.auth_if = uci:get("drcom-auth", "@main[0]", "auth_if") or "eth0"
    data.gateway = uci:get("drcom-auth", "@main[0]", "gateway_host") or "10.255.255.1"
    data.username = uci:get("drcom-auth", "@main[0]", "username") or ""
    data.wan_ip = util.trim(sys.exec("ip -4 addr show " .. data.auth_if .. " 2>/dev/null | awk '/inet /{print $2}' | cut -d/ -f1 | head -n1"))
    data.wan_mac = util.trim(sys.exec("cat /sys/class/net/" .. data.auth_if .. "/address 2>/dev/null | tr 'a-z' 'A-Z'"))
    data.gateway_ok = (sys.call("wget -qO- -T 5 http://" .. data.gateway .. " >/dev/null 2>&1") == 0) and "可达" or "不可达"
    data.internet_ok = (sys.call("/usr/sbin/drcom-auth-watchdog --once >/dev/null 2>&1") == 0) and "正常" or "异常"
    data.state = read_state()
    luci.template.render("drcom_auth/overview", data)
end

function action_exec()
    local op = http.formvalue("op") or ""
    local cmd = nil
    if op == "start" then
        cmd = "/etc/init.d/drcom-auth start"
    elseif op == "stop" then
        cmd = "/etc/init.d/drcom-auth stop"
    elseif op == "restart" then
        cmd = "/etc/init.d/drcom-auth restart"
    elseif op == "once" then
        cmd = "/usr/sbin/drcom-auth-watchdog --once"
    elseif op == "test" then
        cmd = "/usr/sbin/drcom-auth-watchdog --test"
    elseif op == "urls" then
        cmd = "/usr/sbin/drcom-auth-watchdog --print-urls"
    end

    local out = ""
    local ok = false
    if cmd then
        out = sys.exec(cmd .. " 2>&1")
        ok = true
    end

    http.prepare_content("application/json")
    http.write_json({ ok = ok, output = out })
end

function action_logs()
    local n = tonumber(http.formvalue("n") or "200") or 200
    local out = sys.exec(string.format("logread -e drcom-auth-watchdog | tail -n %d", n))
    http.prepare_content("text/plain; charset=utf-8")
    http.write(out or "")
end
