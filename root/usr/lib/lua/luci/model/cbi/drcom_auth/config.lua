m = Map("drcom-auth", "校园网认证", "配置自动认证参数。")

s = m:section(TypedSection, "drcom_auth", "主配置")
s.anonymous = true
s.addremove = false

local f

f = s:option(Flag, "enabled", "启用")
f.rmempty = false

f = s:option(Value, "auth_if", "认证接口")
f.default = "eth0"

f = s:option(Value, "wan_mac", "固定 MAC（可留空自动读取）")

f = s:option(Value, "gateway_host", "网关地址")
f.default = "10.255.255.1"

f = s:option(Value, "login_url", "登录地址")
f.default = "http://10.255.255.1/drcom/login"

f = s:option(Value, "unbind_url", "解绑地址")
f.default = "http://10.255.255.1:801/eportal/portal/mac/unbind"

f = s:option(Value, "username", "账号")
f.password = false

f = s:option(Value, "password", "密码")
f.password = true

f = s:option(Value, "mkkey", "0MKKey")
f.default = "123456"

f = s:option(Value, "check_http_url", "联网检测地址")
f.default = "http://connect.rom.miui.com/generate_204"

f = s:option(Value, "check_http_url_2", "备用检测地址")
f.default = ""

f = s:option(Flag, "http_strict_204", "严格要求 HTTP 204")
f.default = "1"

f = s:option(Value, "success_interval", "正常检测间隔（秒）")
f.datatype = "uinteger"
f.default = "30"

f = s:option(Value, "fail_confirm_delay", "异常二次确认延迟（秒）")
f.datatype = "uinteger"
f.default = "2"

f = s:option(Value, "unbind_delay", "解绑后等待（秒）")
f.datatype = "uinteger"
f.default = "4"

f = s:option(Value, "login_delay", "登录后等待（秒）")
f.datatype = "uinteger"
f.default = "5"

f = s:option(Value, "max_backoff", "最大退避（秒）")
f.datatype = "uinteger"
f.default = "60"

f = s:option(Value, "terminal_type", "终端类型")
f.default = "1"

f = s:option(Value, "js_version", "JS 版本")
f.default = "4.1.3"

f = s:option(Value, "lang_primary", "主语言")
f.default = "zh-cn"

f = s:option(Value, "lang_secondary", "附加语言")
f.default = "zh"

f = s:option(Value, "r1", "R1")
f.default = "0"

f = s:option(Value, "r2", "R2")
f.default = ""

f = s:option(Value, "r3", "R3")
f.default = "0"

f = s:option(Value, "r6", "R6")
f.default = "0"

f = s:option(Value, "para", "para")
f.default = "00"

f = s:option(Value, "v6ip", "v6ip")
f.default = ""

f = s:option(Flag, "unbind_first", "恢复时先解绑")
f.default = "1"

f = s:option(Flag, "log_success", "记录“网络正常”日志")
f.default = "0"

return m
