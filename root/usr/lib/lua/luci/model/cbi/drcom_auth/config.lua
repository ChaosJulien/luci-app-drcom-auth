m = Map("drcom-auth", "校园网认证", "用于 OpenWrt / iStoreOS 的校园网自动检测、解绑与重新登录。")

s = m:section(TypedSection, "main", "基本配置")
s.anonymous = true
s.addremove = false

enabled = s:option(Flag, "enabled", "启用")
enabled.default = enabled.enabled

auth_if = s:option(Value, "auth_if", "认证接口")
auth_if.default = "eth0"

wan_mac = s:option(Value, "wan_mac", "固定 WAN MAC（可选）")
wan_mac.placeholder = "留空则自动读取"

username = s:option(Value, "username", "账号")
username.rmempty = false

password = s:option(Value, "password", "密码")
password.password = true
password.rmempty = false

gateway_host = s:option(Value, "gateway_host", "认证网关")
gateway_host.default = "10.255.255.1"

login_url = s:option(Value, "login_url", "登录接口")
login_url.default = "http://10.255.255.1/drcom/login"

unbind_url = s:option(Value, "unbind_url", "解绑接口")
unbind_url.default = "http://10.255.255.1:801/eportal/portal/mac/unbind"

check_http_url = s:option(Value, "check_http_url", "主检测地址")
check_http_url.default = "http://connect.rom.miui.com/generate_204"

check_http_url_2 = s:option(Value, "check_http_url_2", "备用检测地址")
check_http_url_2.placeholder = "可留空"

strict204 = s:option(Flag, "http_strict_204", "严格要求 HTTP 204")
strict204.default = strict204.enabled

unbind_first = s:option(Flag, "unbind_first", "恢复前先解绑")
unbind_first.default = unbind_first.enabled

success_interval = s:option(Value, "success_interval", "正常检测间隔（秒）")
success_interval.datatype = "uinteger"
success_interval.default = "30"

fail_confirm_delay = s:option(Value, "fail_confirm_delay", "异常确认延迟（秒）")
fail_confirm_delay.datatype = "uinteger"
fail_confirm_delay.default = "2"

unbind_delay = s:option(Value, "unbind_delay", "解绑后等待（秒）")
unbind_delay.datatype = "uinteger"
unbind_delay.default = "4"

login_delay = s:option(Value, "login_delay", "登录后等待（秒）")
login_delay.datatype = "uinteger"
login_delay.default = "5"

retry_delay = s:option(Value, "retry_delay", "失败重试基数（秒）")
retry_delay.datatype = "uinteger"
retry_delay.default = "5"

max_backoff = s:option(Value, "max_backoff", "最大重试等待（秒）")
max_backoff.datatype = "uinteger"
max_backoff.default = "60"

debug = s:option(Flag, "debug", "输出调试日志")
debug.default = debug.disabled

return m
