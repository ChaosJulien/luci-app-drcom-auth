module("luci.controller.drcom_auth", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/drcom-auth") then
		return
	end

	entry({"admin", "services", "drcom_auth"}, firstchild(), _("校园网认证"), 60).dependent = false
	entry({"admin", "services", "drcom_auth", "overview"}, call("action_overview"), _("概览"), 10)
	entry({"admin", "services", "drcom_auth", "config"}, cbi("drcom_auth/config"), _("配置"), 20)
	entry({"admin", "services", "drcom_auth", "action"}, call("action_action"), nil).leaf = true
	entry({"admin", "services", "drcom_auth", "log"}, call("action_log"), nil).leaf = true
end

function _cmd_output(cmd)
	local f = io.popen(cmd .. " 2>/dev/null")
	if not f then return "" end
	local data = f:read("*a") or ""
	f:close()
	return data
end

function action_overview()
	local stat = {}
	stat.service = _cmd_output("/etc/init.d/drcom-auth status | tr -d '\n'")
	stat.ps = _cmd_output("ps | grep drcom-auth-watchdog | grep -v grep")
	stat.wan_ip = _cmd_output("ip -4 addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1 | tr -d '\n'")
	stat.wan_mac = _cmd_output("cat /sys/class/net/eth0/address | tr '[:lower:]' '[:upper:]' | tr -d ':' | tr -d '\n'")
	stat.gateway = _cmd_output("ping -c 1 -W 2 10.255.255.1 >/dev/null && echo 可达 || echo 不可达 | tr -d '\n'")
	stat.logs = _cmd_output("logread -e drcom-auth-watchdog | tail -n 200")
	luci.template.render("drcom_auth/overview", stat)
end

function action_action()
	local http = require "luci.http"
	local action = http.formvalue("do")

	if action == "start" then
		os.execute("/etc/init.d/drcom-auth start >/dev/null 2>&1")
	elseif action == "stop" then
		os.execute("/etc/init.d/drcom-auth stop >/dev/null 2>&1")
	elseif action == "restart" then
		os.execute("/etc/init.d/drcom-auth restart >/dev/null 2>&1")
	elseif action == "once" then
		os.execute("/usr/sbin/drcom-auth-watchdog --once >/dev/null 2>&1")
	elseif action == "test" then
		os.execute("/usr/sbin/drcom-auth-watchdog --test >/tmp/drcom-auth-test.txt 2>&1")
	elseif action == "print" then
		os.execute("/usr/sbin/drcom-auth-watchdog --print-urls >/tmp/drcom-auth-print.txt 2>&1")
	end

	http.redirect(luci.dispatcher.build_url("admin/services/drcom_auth/overview"))
end

function action_log()
	local http = require "luci.http"
	http.prepare_content("text/plain; charset=utf-8")
	http.write(_cmd_output("logread -e drcom-auth-watchdog | tail -n 200"))
end
