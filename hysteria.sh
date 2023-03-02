#/bin/sh

# 日志等级
HYSTERIA_LOG_LEVEL=warn

# 本地http代理端口
HYSTERIA_HTTP_PROXY_PORT=7890
# 本地socks5代理端口
HYSTERIA_SOCKS_PROXY_PORT=1080

proxy() {
  networksetup -setwebproxy wi-fi 127.0.0.1 ${HYSTERIA_HTTP_PROXY_PORT}
  networksetup -setsecurewebproxy wi-fi 127.0.0.1 ${HYSTERIA_HTTP_PROXY_PORT}
  networksetup -setsocksfirewallproxy wi-fi 127.0.0.1 ${HYSTERIA_SOCKS_PROXY_PORT}

  networksetup -setwebproxystate wi-fi on
  networksetup -setsecurewebproxystate wi-fi on
  networksetup -setsocksfirewallproxystate wi-fi on
}

un_proxy() {
  networksetup -setwebproxystate wi-fi off
  networksetup -setsecurewebproxystate wi-fi off
  networksetup -setsocksfirewallproxystate wi-fi off
}

start() {
  HYSTERIA_LOG_LEVEL=${HYSTERIA_LOG_LEVEL} ./hysteria -c ./config.json client > hysteria.log 2>&1 & echo $! > hysteria.pid
  if [ -s hysteria.pid ]; then
    echo "Started hysteria at `cat hysteria.pid`!"
    proxy
  else
    echo "Failed to start hysteria."
  fi
}

stop() {
  un_proxy
  kill `cat hysteria.pid`
  true > hysteria.pid
  echo "Stopped hysteria!"
}

case "$1" in
  "start")
    start
    break
    ;;
  "stop")
    stop
    break
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    ;;
esac
